import 'package:flutter/material.dart';
import 'package:req_res_flutter/app/theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Instead of TextFormField, we use FormField to have more control over the
    // error message and the border color.
    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (FormFieldState<String> state) {
        final theme = Theme.of(context);
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.label,
                  style:
                      theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: hasError
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface,
                      ) ??
                      TextStyle(
                        fontSize: 16,
                        color: hasError ? theme.colorScheme.error : null,
                      ),
                ),
                if (widget.validator != null)
                  Text(
                    '*',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: hasError
                  ? BoxDecoration(borderRadius: BorderRadius.circular(8))
                  : null,
              child: TextField(
                controller: widget.controller,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: hasError ? theme.colorScheme.error : null,
                ),
                onChanged: (value) {
                  if (state.hasError) {
                    state.reset();
                  }
                  state.didChange(value);
                  widget.onChanged?.call(value);
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.iconLight,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
                  enabledBorder: hasError
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  focusedBorder: hasError
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 8),
              Text(
                state.errorText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
