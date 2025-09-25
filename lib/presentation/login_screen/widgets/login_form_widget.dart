import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../localization/app_localizations.dart';

typedef LoginCallback = void Function(String email, String password);

class LoginFormWidget extends StatefulWidget {
  final LoginCallback onLogin;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.onLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailController.text.contains('@');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email/Username Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: AppLocalizations.emailOrUsername,
              hintText: AppLocalizations.enterEmailOrUsername,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'sports_soccer',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.enterEmailOrUsername;
              }
              if (value.contains('@') &&
                  !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                      .hasMatch(value)) {
                return AppLocalizations.invalidEmailAddress;
              }
              return null;
            },
            onChanged: (value) => setState(() {}),
          ),

          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: AppLocalizations.password,
              hintText: AppLocalizations.enterPassword,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.enterPassword;
              }
              if (value.length < 6) {
                return AppLocalizations.passwordTooShort;
              }
              return null;
            },
            onChanged: (value) => setState(() {}),
            onFieldSubmitted: (_) {
              if (_isFormValid && !widget.isLoading) {
                widget.onLogin(_emailController.text, _passwordController.text);
              }
            },
          ),

          SizedBox(height: 1.h),

          // Remember Me and Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: widget.isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.rememberMe,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        // Navigate to forgot password screen
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                child: Text(
                  AppLocalizations.forgotPassword,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: (_isFormValid && !widget.isLoading)
                  ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onLogin(
                            _emailController.text, _passwordController.text);
                      }
                    }
                  : null,
              child: widget.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      AppLocalizations.login,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}