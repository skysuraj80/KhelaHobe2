import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../localization/app_localizations.dart';
import '../../services/auth_service.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignInMode = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    // Check if user is already authenticated
    if (AuthService.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
      });
    }
  }

  Future<void> _handleEmailAuth(String email, String password) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignInMode) {
        await AuthService.signIn(email: email, password: password);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(AppLocalizations.welcomeBack),
              backgroundColor: Colors.green));
          Navigator.pushReplacementNamed(context, AppRoutes.discovery);
        }
      } else {
        // A full name is required for sign up. This will be addressed in a later step.
        await AuthService.signUp(
            email: email, password: password, fullName: 'New User');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Account created successfully! Please check your email for verification.'),
              backgroundColor: Colors.green));
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_getErrorMessage(e.toString())),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return AppLocalizations.invalidEmailOrPassword;
    } else if (error.contains('User already registered')) {
      return AppLocalizations.userAlreadyRegistered;
    } else if (error.contains('Password should be at least')) {
      return AppLocalizations.passwordTooShort;
    } else if (error.contains('Unable to validate email address')) {
      return AppLocalizations.invalidEmailAddress;
    } else {
      return AppLocalizations.somethingWentWrong;
    }
  }

  Future<void> _handleSkipAuth() async {
    // Allow preview mode navigation
    Navigator.pushReplacementNamed(context, AppRoutes.discovery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),

                      // App Logo
                      const AppLogoWidget(),

                      SizedBox(height: 6.h),

                      // Welcome Text
                      Text(
                          _isSignInMode
                              ? AppLocalizations.welcomeBack
                              : AppLocalizations.joinSportMatch,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center),

                      SizedBox(height: 2.h),

                      Text(
                          _isSignInMode
                              ? AppLocalizations.signInToContinue
                              : AppLocalizations.createYourAccount,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center),

                      SizedBox(height: 4.h),

                      // Auth Form
                      LoginFormWidget(
                        isLoading: _isLoading,
                        onLogin: _handleEmailAuth,
                      ),

                      SizedBox(height: 3.h),

                      // Toggle Sign In/Sign Up
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _isSignInMode
                                    ? AppLocalizations.dontHaveAnAccount
                                    : AppLocalizations.alreadyHaveAnAccount,
                                style: Theme.of(context).textTheme.bodyMedium),
                            TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _isSignInMode = !_isSignInMode;
                                        });
                                      },
                                child: Text(
                                    _isSignInMode
                                        ? AppLocalizations.signUp
                                        : AppLocalizations.signIn,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w600))),
                          ]),

                      SizedBox(height: 4.h),

                      // Divider
                      Row(children: [
                        const Expanded(child: Divider()),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(AppLocalizations.orContinueWith,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey))),
                        const Expanded(child: Divider()),
                      ]),

                      SizedBox(height: 4.h),

                      // Social Login Options
                      SocialLoginWidget(
                        isLoading: _isLoading,
                        onSocialLogin: (provider) async {
                          // Handle social login
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Biometric Login (for existing users)
                      if (_isSignInMode)
                        BiometricLoginWidget(
                          isAvailable: true,
                          isLoading: _isLoading,
                          onBiometricLogin: () async {
                            // Handle biometric login
                          },
                        ),

                      SizedBox(height: 4.h),

                      // Preview Mode Button
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300)),
                          child: Column(children: [
                            Icon(Icons.visibility,
                                size: 32, color: Colors.orange),
                            SizedBox(height: 1.h),
                            Text(AppLocalizations.previewMode,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade800)),
                            SizedBox(height: 0.5.h),
                            Text(AppLocalizations.exploreTheApp,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                                textAlign: TextAlign.center),
                            SizedBox(height: 2.h),
                            ElevatedButton(
                                onPressed: _isLoading ? null : _handleSkipAuth,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(50.w, 48)),
                                child: const Text(AppLocalizations.tryPreview)),
                          ])),

                      SizedBox(height: 4.h),

                      // Terms and Privacy
                      Text(AppLocalizations.termsAndPrivacy,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                          textAlign: TextAlign.center),

                      SizedBox(height: 3.h),
                    ]))));
  }
}
