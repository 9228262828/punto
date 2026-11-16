import 'package:flutter/material.dart';

const puntoPurple = Color(0xFF635BDB);
const puntoLime = Color(0xFFC9F36A);
const puntoOrange = Color(0xFFFFA66B);

const playerColors = <Color>[
  Color(0xFF6C63E6),
  Color(0xFF00A89D),
  Color(0xFFFF9A62),
  Color(0xFFDA6B9B),
  Color(0xFF4E9BD5),
  Color(0xFF9A77CE),
  Color(0xFFB5A13B),
  Color(0xFF5FAD78),
];

ThemeData buildPuntoTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: puntoPurple,
    brightness: brightness,
    surface: dark ? const Color(0xFF191925) : Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        dark ? const Color(0xFF11111A) : const Color(0xFFF5F4FA),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xFF11111A) : const Color(0xFFF5F4FA),
      foregroundColor: dark ? Colors.white : const Color(0xFF202033),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF1D1D2B) : Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF252536) : const Color(0xFFF1F0F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: puntoPurple, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: puntoPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide.none,
      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
    dividerTheme: DividerThemeData(
      color: dark ? Colors.white12 : Colors.black12,
      space: 1,
    ),
  );
}

class PuntoLogo extends StatelessWidget {
  const PuntoLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 46,
          height: compact ? 38 : 46,
          decoration: BoxDecoration(
            color: puntoPurple,
            borderRadius: BorderRadius.circular(compact ? 13 : 16),
          ),
          child: const Icon(Icons.bubble_chart_rounded,
              color: Colors.white, size: 27),
        ),
        const SizedBox(width: 10),
        Text(
          'PUNTO',
          style: TextStyle(
            fontSize: compact ? 20 : 25,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}

String formatShortDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? 'PM' : 'AM';
  return '${months[date.month - 1]} ${date.day} · $hour:$minute $period';
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.55),
              ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
