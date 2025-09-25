-- Location: supabase/migrations/20250118133336_sports_matchmaking_app.sql
-- Schema Analysis: Fresh Supabase project with no existing schema
-- Integration Type: Complete schema creation for sports matchmaking app
-- Module: Complete sports matchmaking system with authentication

-- 1. Create custom types first
CREATE TYPE public.user_status AS ENUM ('active', 'inactive', 'banned');
CREATE TYPE public.sport_type AS ENUM ('football', 'basketball', 'tennis', 'badminton', 'cricket', 'volleyball', 'swimming', 'running', 'cycling', 'other');
CREATE TYPE public.skill_level AS ENUM ('beginner', 'intermediate', 'advanced', 'professional');
CREATE TYPE public.match_status AS ENUM ('pending', 'matched', 'rejected');
CREATE TYPE public.game_status AS ENUM ('open', 'full', 'cancelled', 'completed');
CREATE TYPE public.chat_message_type AS ENUM ('text', 'image', 'system');

-- 2. Core user profile table (references auth.users)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    bio TEXT,
    profile_image_url TEXT,
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION,
    location_name TEXT,
    age INTEGER CHECK (age >= 13 AND age <= 100),
    status public.user_status DEFAULT 'active'::public.user_status,
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. User sports preferences
CREATE TABLE public.user_sports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    sport_type public.sport_type NOT NULL,
    skill_level public.skill_level NOT NULL,
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Games/matches table
CREATE TABLE public.games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    sport_type public.sport_type NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    location_name TEXT NOT NULL,
    location_lat DOUBLE PRECISION NOT NULL,
    location_lng DOUBLE PRECISION NOT NULL,
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    max_players INTEGER NOT NULL DEFAULT 2 CHECK (max_players >= 2),
    cost_per_player DECIMAL(10,2) DEFAULT 0.00,
    status public.game_status DEFAULT 'open'::public.game_status,
    required_skill_level public.skill_level,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Game participants
CREATE TABLE public.game_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID REFERENCES public.games(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, user_id)
);

-- 6. User discovery/matching system
CREATE TABLE public.user_matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    target_user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    status public.match_status DEFAULT 'pending'::public.match_status,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, target_user_id),
    CHECK (user_id != target_user_id)
);

-- 7. Chat rooms for matched users
CREATE TABLE public.chat_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user1_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    user2_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    last_message_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user1_id, user2_id),
    CHECK (user1_id != user2_id)
);

-- 8. Chat messages
CREATE TABLE public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chat_room_id UUID REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    message_type public.chat_message_type DEFAULT 'text'::public.chat_message_type,
    content TEXT NOT NULL,
    image_url TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 9. Essential indexes for performance
CREATE INDEX idx_user_profiles_location ON public.user_profiles(location_lat, location_lng);
CREATE INDEX idx_user_sports_user_id ON public.user_sports(user_id);
CREATE INDEX idx_user_sports_sport_type ON public.user_sports(sport_type);
CREATE INDEX idx_games_host_id ON public.games(host_id);
CREATE INDEX idx_games_location ON public.games(location_lat, location_lng);
CREATE INDEX idx_games_sport_scheduled ON public.games(sport_type, scheduled_date, scheduled_time);
CREATE INDEX idx_games_status ON public.games(status);
CREATE INDEX idx_game_participants_game_id ON public.game_participants(game_id);
CREATE INDEX idx_game_participants_user_id ON public.game_participants(user_id);
CREATE INDEX idx_user_matches_user_id ON public.user_matches(user_id);
CREATE INDEX idx_user_matches_target_user_id ON public.user_matches(target_user_id);
CREATE INDEX idx_user_matches_status ON public.user_matches(status);
CREATE INDEX idx_chat_rooms_users ON public.chat_rooms(user1_id, user2_id);
CREATE INDEX idx_chat_messages_room_id ON public.chat_messages(chat_room_id);
CREATE INDEX idx_chat_messages_sender_id ON public.chat_messages(sender_id);
CREATE INDEX idx_chat_messages_created_at ON public.chat_messages(created_at);

-- 10. Enable RLS on all tables
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_sports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.games ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.game_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- 11. Storage buckets for profile images
INSERT INTO storage.buckets (id, name, public)
VALUES ('profile-images', 'profile-images', true);

-- 12. Functions (MUST BE BEFORE RLS POLICIES)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.is_chat_participant(room_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.chat_rooms cr
    WHERE cr.id = room_id
    AND (cr.user1_id = auth.uid() OR cr.user2_id = auth.uid())
)
$$;

CREATE OR REPLACE FUNCTION public.can_join_game(game_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.games g
    LEFT JOIN public.game_participants gp ON g.id = gp.game_id
    WHERE g.id = game_uuid
    AND g.status = 'open'::public.game_status
    AND g.host_id != auth.uid()
    GROUP BY g.id, g.max_players
    HAVING COUNT(gp.id) < g.max_players
)
$$;

-- 13. RLS Policies using corrected patterns
-- Pattern 1: Core user table - simple direct reference
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 2: Simple user ownership
CREATE POLICY "users_manage_own_user_sports"
ON public.user_sports
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Pattern 4: Public read, private write for games
CREATE POLICY "public_can_view_games"
ON public.games
FOR SELECT
TO public
USING (true);

CREATE POLICY "users_manage_own_games"
ON public.games
FOR ALL
TO authenticated
USING (host_id = auth.uid())
WITH CHECK (host_id = auth.uid());

-- Game participants - can view if participant or host
CREATE POLICY "participants_view_game_participants"
ON public.game_participants
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid() 
    OR EXISTS (
        SELECT 1 FROM public.games g 
        WHERE g.id = game_id AND g.host_id = auth.uid()
    )
);

CREATE POLICY "users_join_games"
ON public.game_participants
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid() AND public.can_join_game(game_id));

CREATE POLICY "users_leave_games"
ON public.game_participants
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- Pattern 2: Simple user ownership for matches
CREATE POLICY "users_manage_own_matches"
ON public.user_matches
FOR ALL
TO authenticated
USING (user_id = auth.uid() OR target_user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Chat rooms - participants only
CREATE POLICY "participants_access_chat_rooms"
ON public.chat_rooms
FOR ALL
TO authenticated
USING (user1_id = auth.uid() OR user2_id = auth.uid())
WITH CHECK (user1_id = auth.uid() OR user2_id = auth.uid());

-- Chat messages - room participants only
CREATE POLICY "participants_view_chat_messages"
ON public.chat_messages
FOR SELECT
TO authenticated
USING (public.is_chat_participant(chat_room_id));

CREATE POLICY "participants_send_messages"
ON public.chat_messages
FOR INSERT
TO authenticated
WITH CHECK (sender_id = auth.uid() AND public.is_chat_participant(chat_room_id));

-- Storage policies for profile images
CREATE POLICY "users_view_profile_images"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'profile-images');

CREATE POLICY "users_upload_own_profile_images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'profile-images' 
    AND owner = auth.uid()
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "users_update_own_profile_images"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'profile-images' AND owner = auth.uid())
WITH CHECK (bucket_id = 'profile-images' AND owner = auth.uid());

CREATE POLICY "users_delete_own_profile_images"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'profile-images' AND owner = auth.uid());

-- 14. Trigger for automatic profile creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 15. Mock data for testing
DO $$
DECLARE
    user1_id UUID := gen_random_uuid();
    user2_id UUID := gen_random_uuid();
    user3_id UUID := gen_random_uuid();
    game1_id UUID := gen_random_uuid();
    game2_id UUID := gen_random_uuid();
    chat_room_id UUID := gen_random_uuid();
BEGIN
    -- Create mock auth users
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user1_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'john@sportmatch.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "John Doe"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user2_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'sarah@sportmatch.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Johnson"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user3_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'mike@sportmatch.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Mike Wilson"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Update user profiles with additional data
    UPDATE public.user_profiles SET 
        bio = 'Passionate football player looking for weekend games!',
        location_lat = 40.7128,
        location_lng = -74.0060,
        location_name = 'New York, NY',
        age = 28,
        profile_image_url = 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg'
    WHERE id = user1_id;

    UPDATE public.user_profiles SET 
        bio = 'Tennis enthusiast and weekend warrior. Always up for a challenge!',
        location_lat = 40.7589,
        location_lng = -73.9851,
        location_name = 'Central Park, NY',
        age = 25,
        profile_image_url = 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg'
    WHERE id = user2_id;

    UPDATE public.user_profiles SET 
        bio = 'Basketball coach and player. Love teaching the game to others.',
        location_lat = 40.7505,
        location_lng = -73.9934,
        location_name = 'Times Square, NY',
        age = 32,
        profile_image_url = 'https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg'
    WHERE id = user3_id;

    -- Insert user sports preferences
    INSERT INTO public.user_sports (user_id, sport_type, skill_level, is_primary) VALUES
        (user1_id, 'football'::public.sport_type, 'intermediate'::public.skill_level, true),
        (user1_id, 'basketball'::public.sport_type, 'beginner'::public.skill_level, false),
        (user2_id, 'tennis'::public.sport_type, 'advanced'::public.skill_level, true),
        (user2_id, 'badminton'::public.sport_type, 'intermediate'::public.skill_level, false),
        (user3_id, 'basketball'::public.sport_type, 'professional'::public.skill_level, true),
        (user3_id, 'football'::public.sport_type, 'advanced'::public.skill_level, false);

    -- Insert sample games
    INSERT INTO public.games (id, host_id, sport_type, title, description, location_name, location_lat, location_lng, scheduled_date, scheduled_time, max_players, cost_per_player, required_skill_level) VALUES
        (game1_id, user1_id, 'football'::public.sport_type, 'Sunday Morning Football', 'Casual game in Central Park. Bring water and good vibes!', 'Central Park Great Lawn', 40.7829, -73.9654, CURRENT_DATE + INTERVAL '3 days', '10:00:00', 10, 5.00, 'intermediate'::public.skill_level),
        (game2_id, user2_id, 'tennis'::public.sport_type, 'Evening Tennis Match', 'Looking for doubles partner for evening match. All levels welcome!', 'Bryant Park Tennis', 40.7536, -73.9832, CURRENT_DATE + INTERVAL '2 days', '18:30:00', 4, 15.00, 'beginner'::public.skill_level);

    -- Create some matches
    INSERT INTO public.user_matches (user_id, target_user_id, status) VALUES
        (user1_id, user2_id, 'matched'::public.match_status),
        (user2_id, user3_id, 'pending'::public.match_status),
        (user3_id, user1_id, 'matched'::public.match_status);

    -- Create chat rooms for matched users
    INSERT INTO public.chat_rooms (id, user1_id, user2_id) VALUES
        (chat_room_id, user1_id, user2_id);

    -- Add some chat messages
    INSERT INTO public.chat_messages (chat_room_id, sender_id, content) VALUES
        (chat_room_id, user1_id, 'Hey! I saw you''re into tennis. Want to play this weekend?'),
        (chat_room_id, user2_id, 'That sounds great! I''m free Saturday morning.'),
        (chat_room_id, user1_id, 'Perfect! I''ll create a game and send you the details.');

    -- Add some game participants
    INSERT INTO public.game_participants (game_id, user_id) VALUES
        (game1_id, user3_id),
        (game2_id, user1_id);

END $$;