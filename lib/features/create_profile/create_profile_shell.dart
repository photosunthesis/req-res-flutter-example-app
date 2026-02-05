import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:req_res_flutter/features/create_profile/components/profile_progress_indicator.dart';
import 'package:req_res_flutter/features/create_profile/create_profile_notifier.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

class CreateProfileShell extends ConsumerStatefulWidget {
  const CreateProfileShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CreateProfileShell> createState() => _CreateProfileShellState();
}

class _CreateProfileShellState extends ConsumerState<CreateProfileShell> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final path = GoRouterState.of(context).uri.path;
    var currentStep = CreateProfileStep.setDisplayName;
    if (path.contains('set-profile-photo')) {
      currentStep = CreateProfileStep.setProfilePicture;
    } else if (path.contains('set-username')) {
      currentStep = CreateProfileStep.setUsername;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(createProfileNotifierProvider).currentStep != currentStep) {
        ref
            .read(createProfileNotifierProvider.notifier)
            .setCurrentStep(currentStep);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createProfileNotifierProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.createYourProfile,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: context.pop,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileProgressIndicator(currentStep: state.currentStep.index),
              const SizedBox(height: 40),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
