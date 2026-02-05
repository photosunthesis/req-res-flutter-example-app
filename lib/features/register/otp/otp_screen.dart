import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.email});

  final String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late final _l10n = AppLocalizations.of(context)!;
  late final _theme = Theme.of(context);

  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  int _remainingSeconds = 300;
  Timer? _timer;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pinController.addListener(() {
      final isEnabled = _pinController.text.length == 6;
      if (_isButtonEnabled != isEnabled) {
        setState(() => _isButtonEnabled = isEnabled);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.colorScheme.surface,
      appBar: _buildAppBar(),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildDescription(),
                    const SizedBox(height: 32),
                    _buildPinInput(),
                    const SizedBox(height: 24),
                    _buildTimer(),
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
                  _buildResendButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textDark,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        _l10n.otpTitle,
        style: _theme.textTheme.titleMedium?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildDescription() {
    return Text(
      _l10n.otpDescription,
      textAlign: TextAlign.center,
      style: _theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        height: 1.5,
      ),
    );
  }

  Widget _buildPinInput() {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: AppColors.textDark,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: Colors.white),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: _l10n.enterOtpLabel,
            style: _theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Pinput(
          length: 6,
          controller: _pinController,
          focusNode: _focusNode,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          separatorBuilder: (index) => const SizedBox(width: 8),
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 2,
                height: 20,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: _l10n.codeExpiringIn,
          style: _theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
          children: [
            TextSpan(
              text: '$_remainingSeconds ${_l10n.seconds}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
            // For this example app, any OTP is valid. In a real app, we would
            // call an API to verify the OTP. For now, we take note of the email
            // and navigate to the create password screen.
            ? () async => context.pushNamed(
                AppRoutes.createPassword,
                queryParameters: {'email': widget.email},
              )
            : null,
        child: Text(
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

  Widget _buildResendButton() {
    return Center(
      child: TextButton(
        onPressed: _remainingSeconds == 0 ? _startTimer : null,
        child: Text(
          _l10n.resendCode,
          style: _theme.textTheme.bodyLarge?.copyWith(
            color: _remainingSeconds == 0
                ? AppColors.primaryDark
                : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
