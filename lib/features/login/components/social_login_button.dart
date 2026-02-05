import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:req_res_flutter/app/theme.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 42, right: 12),
          child: Row(
            mainAxisAlignment: .start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  iconPath,
                  placeholderBuilder: (BuildContext context) => const Icon(
                    Icons.error_outline,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
