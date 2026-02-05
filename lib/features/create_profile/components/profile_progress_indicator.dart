import 'package:flutter/material.dart';
import 'package:req_res_flutter/app/theme.dart';

class ProfileProgressIndicator extends StatelessWidget {
  const ProfileProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _buildStepCircle(stepIndex);
          } else {
            final lineIndex = index ~/ 2;
            return _buildConnectingLine(lineIndex);
          }
        }),
      ),
    );
  }

  Widget _buildStepCircle(int stepIndex) {
    final isCompleted = stepIndex < currentStep;
    final isCurrent = stepIndex == currentStep;

    if (isCurrent) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else if (isCompleted) {
      return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: AppColors.primaryDark,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 12),
      );
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.iconLight, width: 2.5),
        ),
      );
    }
  }

  Widget _buildConnectingLine(int lineIndex) {
    final isCompleted = lineIndex < currentStep;
    final isNext = lineIndex == currentStep;

    if (isNext) {
      return Expanded(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(height: 4, color: AppColors.iconLight),
            Container(
              width: 6,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Container(
        height: 4,
        color: isCompleted ? AppColors.primaryDark : AppColors.iconLight,
      ),
    );
  }
}
