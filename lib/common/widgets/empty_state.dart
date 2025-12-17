import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: cs.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (buttonText != null && onPressed != null) ...[
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: onPressed,
                  child: Text(buttonText!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
