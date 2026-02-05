import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:req_res_flutter/app/router.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/constants/icons.dart';

import 'package:req_res_flutter/features/create_profile/create_profile_notifier.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

class SetProfilePhotoScreen extends ConsumerStatefulWidget {
  const SetProfilePhotoScreen({super.key});

  @override
  ConsumerState<SetProfilePhotoScreen> createState() =>
      _SetProfilePhotoScreenState();
}

class _SetProfilePhotoScreenState extends ConsumerState<SetProfilePhotoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(createProfileNotifierProvider.notifier)
          .setCurrentStep(CreateProfileStep.setProfilePicture);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createProfileNotifierProvider);
    final notifier = ref.read(createProfileNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          l10n.profilePicture,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 32),
        _buildProfileAvatar(state.profilePhotoPath),
        const SizedBox(height: 48),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                iconPath: AppIcons.camera,
                label: l10n.takeAPhoto,
                onTap: () async => notifier.pickImage(ImageSource.camera),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                iconPath: AppIcons.upload,
                label: l10n.uploadAPhoto,
                onTap: () async => notifier.pickImage(ImageSource.gallery),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        _buildNextButton(state, l10n),
      ],
    );
  }

  Widget _buildProfileAvatar(String? path) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: path != null
            ? Image.file(File(path), fit: BoxFit.cover)
            : Center(
                child: SvgPicture.asset(
                  AppIcons.addPhoto,
                  width: 64,
                  height: 64,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconLight,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(CreateProfileState state, AppLocalizations l10n) {
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
        onPressed: () {
          ref.read(createProfileNotifierProvider.notifier).submitProfilePicture();
          context.goNamed(AppRoutes.home);
        },
        child: Text(
          l10n.next,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
