import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/features/register/create_password/create_password_notifier.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';
import 'package:req_res_flutter/ui_components/custom_text_field.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  late final _l10n = AppLocalizations.of(context)!;
  late final _theme = Theme.of(context);

  final _passwordController = TextEditingController();
  var _agreedToTerms = false;
  var _showTermsError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createPasswordNotifierProvider.notifier).setEmail(widget.email);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPasswordNotifierProvider);

    ref.listen(createPasswordNotifierProvider, (_, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }

      if (state.didSignUp) {
        context.goNamed(AppRoutes.createProfileSetNames);
      }
    });

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: _theme.colorScheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildPasswordField(),
                      const SizedBox(height: 24),
                      _buildRequirementsList(state),
                      const SizedBox(height: 32),
                      _buildSignUpButton(state),
                      const SizedBox(height: 24),
                      _buildTermsCheckbox(),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    const SizedBox(height: 24),
                    _buildSignInRow(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      _l10n.createPassword,
      style: _theme.textTheme.headlineMedium!.copyWith(
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: _l10n.passwordLabel,
      hintText: _l10n.passwordHint,
      controller: _passwordController,
      isPassword: true,
      onChanged: (value) =>
          ref.read(createPasswordNotifierProvider.notifier).setPassword(value),
    );
  }

  Widget _buildRequirementsList(CreatePasswordState state) {
    return Column(
      children: [
        _buildRequirementItem(_l10n.requirementLength, state.hasMinLength),
        const SizedBox(height: 8),
        _buildRequirementItem(_l10n.requirementUppercase, state.hasUppercase),
        const SizedBox(height: 8),
        _buildRequirementItem(
          _l10n.requirementAlphanumeric,
          state.isAlphanumeric,
        ),
        const SizedBox(height: 8),
        _buildRequirementItem(
          _l10n.requirementSpecialChars,
          state.hasSpecialChars,
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          Icons.check_rounded,
          size: 20,
          color: isValid ? AppColors.primaryDark : AppColors.iconLight,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: _theme.textTheme.bodyMedium?.copyWith(
              color: isValid ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(CreatePasswordState state) {
    final isEnabled = state.isPasswordValid && !state.isLoading;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? AppColors.primaryGradient
            : AppColors.primaryGradientDisabled,
        borderRadius: BorderRadius.circular(999),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: isEnabled
            ? () async {
                FocusScope.of(context).unfocus();

                if (!_agreedToTerms) {
                  setState(() => _showTermsError = true);
                  return;
                }
                setState(() {
                  _showTermsError = false;
                });

                await ref
                    .read(createPasswordNotifierProvider.notifier)
                    .signUp();
              }
            : null,
        child: state.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                _l10n.signUp,
                style: _theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxRow(),
        if (_showTermsError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              _l10n.termsError,
              style: _theme.textTheme.bodySmall?.copyWith(
                color: _theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxRow() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _agreedToTerms = !_agreedToTerms;
          if (_agreedToTerms) _showTermsError = false;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: _agreedToTerms,
              onChanged: (value) =>
                  setState(() => _agreedToTerms = value ?? false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: _l10n.termsAgreementStart,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
                children: [
                  _buildLinkSpan(_l10n.termsOfUse),
                  const TextSpan(text: ', '),
                  _buildLinkSpan(_l10n.privacyPolicy),
                  const TextSpan(text: ', '),
                  _buildLinkSpan(_l10n.communityGuidelines),
                  const TextSpan(text: ', '),
                  TextSpan(text: _l10n.andText),
                  _buildLinkSpan(_l10n.cookiePolicy),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildLinkSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSignInRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _l10n.alreadyHaveAccount,
            style: _theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () => context.goNamed(AppRoutes.login),
            child: Text(
              _l10n.signIn,
              style: _theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
