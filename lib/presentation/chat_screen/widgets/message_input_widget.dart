import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class MessageInputWidget extends StatefulWidget {
  final ValueChanged<String> onSendMessage;
  final ValueChanged<String> onSendImage;
  final ValueChanged<String> onSendAudio;
  final VoidCallback onGameProposal;
  final VoidCallback? onTypingStart;
  final VoidCallback? onTypingStop;

  const MessageInputWidget({
    Key? key,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendAudio,
    required this.onGameProposal,
    this.onTypingStart,
    this.onTypingStop,
  }) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isTyping = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _focusNode.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isCurrentlyTyping = _messageController.text.isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
      if (isCurrentlyTyping) {
        widget.onTypingStart?.call();
      } else {
        widget.onTypingStop?.call();
      }
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
      widget.onTypingStop?.call();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        widget.onSendImage(image.path);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        widget.onSendImage(image.path);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              title: Text(
                'Take Photo',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              title: Text(
                'Choose from Gallery',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      bool hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) return;

      if (await _audioRecorder.hasPermission()) {
        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          final directory = await getTemporaryDirectory();
          _recordingPath =
              '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: _recordingPath!,
          );
        }

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        widget.onSendAudio(path);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _showSportsEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        height: 4.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              AppLocalizations.sportsEmojis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 6,
                children: [
                  '⚽',
                  '🏀',
                  '🏈',
                  '⚾',
                  '🎾',
                  '🏐',
                  '🏓',
                  '🏸',
                  '🥊',
                  '🏊',
                  '🚴',
                  '🏃',
                  '⛷️',
                  '🏂',
                  '🏌️',
                  '🏹',
                  '🎯',
                  '🥅',
                  '🏆',
                  '🥇',
                  '🥈',
                  '🥉',
                  '🏅',
                  '🎖️',
                ]
                    .map((emoji) => GestureDetector(
                          onTap: () {
                            _messageController.text += emoji;
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(2.w),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline
                                    .withAlpha((255 * 0.3).round()),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                emoji,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                Theme.of(context).colorScheme.outline.withAlpha((255 * 0.3).round()),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary
                      .withAlpha((255 * 0.1).round()),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: widget.onGameProposal,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary
                      .withAlpha((255 * 0.1).round()),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'sports_tennis',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline
                        .withAlpha((255 * 0.3).round()),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showSportsEmojiPicker,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: Text(
                          '⚽',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.typeAMessage,
                          hintStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 2.h,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 2.w),
            _isTyping
                ? GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'send',
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  )
                : GestureDetector(
                    onLongPressStart: (_) => _startRecording(),
                    onLongPressEnd: (_) => _stopRecording(),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _isRecording
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: _isRecording ? 'stop' : 'mic',
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 20,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
