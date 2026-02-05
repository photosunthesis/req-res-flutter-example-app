import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';
// ignore: unused_import
import 'package:req_res_flutter/ui_components/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final _l10n = AppLocalizations.of(context)!;
  late final _theme = Theme.of(context);

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _errorMessage = '';
  var _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      final isEnabled = _emailController.text.isNotEmpty;
      if (_isButtonEnabled != isEnabled) {
        setState(() => _isButtonEnabled = isEnabled);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: 24),
                    _buildForm(),
                    const SizedBox(height: 32),
                    _buildNextButton(),
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
    );
  }

  Widget _buildHeader() {
    return Text(
      _l10n.signUp,
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
                _errorMessage = _l10n.requiredFieldError;
              }

              // Typically, a more robust validation would be performed here.
              // For example, checking if the email is valid or if the phone number
              // is in the correct format. For now we will simply check if the input
              // is a valid email with a simple regex.

              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

              if (!emailRegex.hasMatch(value!)) {
                _errorMessage = _l10n.ensureCorrectEmailError;
              }

              if (_errorMessage.isNotEmpty) return _errorMessage;

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: _isButtonEnabled
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
        onPressed: _isButtonEnabled
            ? () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isLoading = true);

                  // Typically we would call our Notifier/Bloc here but
                  // since ReqRes doesn't implement a confirm email endpoint,
                  // we will take note of the email and navigate to the OTP screen.

                  context.pushNamed(
                    AppRoutes.otp,
                    queryParameters: {'email': _emailController.text},
                  );

                  setState(() => _isLoading = false);
                }
              }
            : null,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                _l10n.next,
                style: _theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
