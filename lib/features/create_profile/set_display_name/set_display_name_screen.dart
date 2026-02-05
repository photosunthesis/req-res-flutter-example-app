import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/features/create_profile/create_profile_notifier.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';
import 'package:req_res_flutter/ui_components/custom_text_field.dart';

class SetDisplayNameScreen extends ConsumerStatefulWidget {
  const SetDisplayNameScreen({super.key});

  @override
  ConsumerState<SetDisplayNameScreen> createState() =>
      _SetDisplayNameScreenState();
}

class _SetDisplayNameScreenState extends ConsumerState<SetDisplayNameScreen> {
  late final _theme = Theme.of(context);
  late final _l10n = AppLocalizations.of(context)!;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  var _canSubmit = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(createProfileNotifierProvider.notifier)
          .setCurrentStep(CreateProfileStep.setDisplayName);
    });

    _firstNameController.addListener(_updateButtonState);
    _lastNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final canSubmit =
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty;

    if (_canSubmit != canSubmit) {
      setState(() => _canSubmit = canSubmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildForm(), const SizedBox(height: 32), _buildNextButton()],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: _l10n.firstName,
            hintText: _l10n.enterFirstName,
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _l10n.firstNameRequired;
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: _l10n.lastName,
            hintText: _l10n.enterLastName,
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _l10n.lastNameRequired;
              }

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
        gradient: _canSubmit
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
        onPressed: _canSubmit
            ? () async {
                if (_formKey.currentState!.validate()) {
                  await ref
                      .read(createProfileNotifierProvider.notifier)
                      .setDisplayName(
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                      );

                  // ignore: use_build_context_synchronously
                  context.pushNamed(AppRoutes.createProfileSetUsername);
                }
              }
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
}
