import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/features/create_profile/create_profile_notifier.dart';

import 'package:req_res_flutter/l10n/app_localizations.dart';
import 'package:req_res_flutter/ui_components/custom_text_field.dart';

class SetUsernameScreen extends ConsumerStatefulWidget {
  const SetUsernameScreen({super.key});

  @override
  ConsumerState<SetUsernameScreen> createState() => _SetUsernameState();
}

class _SetUsernameState extends ConsumerState<SetUsernameScreen> {
  final _usernameController = TextEditingController();
  late final _theme = Theme.of(context);
  late final _l10n = AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(createProfileNotifierProvider.notifier)
          .setCurrentStep(CreateProfileStep.setUsername);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createProfileNotifierProvider);

    ref.listen(createProfileNotifierProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: _l10n.username,
          hintText: _l10n.enterUsername,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            return null;
          },
          controller: _usernameController,
          keyboardType: TextInputType.text,
          autofillHints: const [AutofillHints.username],
          onChanged: (value) {
            ref.read(createProfileNotifierProvider.notifier).setUsername(value);
          },
        ),
        const SizedBox(height: 24),
        _buildValidationItem(state.hasMinLength, _l10n.minLength8),
        _buildValidationItem(state.hasUppercase, _l10n.oneUppercase),
        _buildValidationItem(state.isAlphanumeric, _l10n.alphanumeric),
        _buildValidationItem(state.hasSpecialChars, _l10n.acceptedSpecialChars),
        const SizedBox(height: 32),
        _buildNextButton(state),
      ],
    );
  }

  Widget _buildValidationItem(bool isValid, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check,
            size: 20,
            color: isValid ? AppColors.textDark : AppColors.iconLight,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: _theme.textTheme.bodyMedium?.copyWith(
              color: isValid ? AppColors.textDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(CreateProfileState state) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: state.isUsernameValid
            ? AppColors.primaryGradient
            : AppColors.primaryGradientDisabled,
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
        onPressed: state.isUsernameValid
            ? () async {
                FocusScope.of(context).unfocus();
                await ref
                    .read(createProfileNotifierProvider.notifier)
                    .submitUsername();

                // ignore: use_build_context_synchronously
                context.pushNamed(AppRoutes.createProfileSetPhoto);
              }
            : null,
        child: state.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                _l10n.next,
                style: _theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
