import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/constants/icons.dart';
import 'package:req_res_flutter/features/login/components/social_login_button.dart';
import 'package:req_res_flutter/features/login/login_notifier.dart';
import 'package:req_res_flutter/features/login/login_state.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';
import 'package:req_res_flutter/ui_components/custom_text_field.dart';
import 'package:req_res_flutter/features/login/components/custom_info_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final _l10n = AppLocalizations.of(context)!;
  late final _theme = Theme.of(context);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginNotifierProvider, (_, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: _theme.colorScheme.error,
          ),
        );
      }

      if (state.isSuccess) {
        context.goNamed(AppRoutes.home);
      }
    });

    return Scaffold(
      backgroundColor: _theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildForm(),
              const SizedBox(height: 12),
              _buildForgotPasswordAction(),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 24),
              _buildTermsAndConditions(),
              const SizedBox(height: 32),
              _buildSignUpRow(),
              const SizedBox(height: 32),
              _buildSocialLoginButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      _l10n.loginTitle,
      style: _theme.textTheme.headlineMedium!.copyWith(
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: _l10n.emailOrMobileLabel,
            hintText: _l10n.emailOrMobileHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _l10n.emailOrMobileError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: _l10n.passwordLabel,
            hintText: _l10n.passwordHint,
            isPassword: true,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.password],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _l10n.passwordError;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordAction() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _showAccountLockedDialog,
        child: Text(
          _l10n.forgotPassword,
          style: _theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.isLoading;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(999),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(loginNotifierProvider.notifier)
                      .login(_emailController.text, _passwordController.text);
                }
              },
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _l10n.loginButton,
                style: _theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _showTermsDialog,
            child: RichText(
              text: TextSpan(
                text: _l10n.termsAgreementStart,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: _l10n.termsOfUse,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ', '),
                  TextSpan(
                    text: _l10n.privacyPolicy,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ', '),
                  TextSpan(
                    text: _l10n.communityGuidelines,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: _l10n.andText),
                  TextSpan(
                    text: _l10n.cookiePolicy,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAccountLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomInfoDialog(
        title: _l10n.accountLockedTitle,
        description: _l10n.accountLockedMessage,
        primaryButtonText: _l10n.forgotPasswordButton,
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomInfoDialog(
        title: _l10n.termsConsentTitle,
        description: _l10n.termsConsentMessage,
        primaryButtonText: _l10n.agreeButton,
        secondaryButtonText: _l10n.disagreeButton,
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _l10n.noAccountText,
          style: _theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.signUp),
          child: Text(
            _l10n.signUp,
            style: _theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SocialLoginButton(
          text: _l10n.continueWithGoogle,
          iconPath: AppIcons.google,
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        SocialLoginButton(
          text: _l10n.continueWithFacebook,
          iconPath: AppIcons.facebook,
          onPressed: () {},
        ),
      ],
    );
  }
}
