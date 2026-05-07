import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/locale_provider.dart';

class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key, this.isDark = true});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final label = locale.languageCode == 'en' ? 'AR' : 'EN';

    return TextButton(
      onPressed: () => ref.read(localeProvider.notifier).toggle(),
      style: TextButton.styleFrom(
        foregroundColor:
            isDark ? Colors.white : Theme.of(context).colorScheme.primary,
        visualDensity: VisualDensity.compact,
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
