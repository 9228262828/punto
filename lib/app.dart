import 'package:flutter/material.dart';

import 'screens.dart';
import 'store.dart';
import 'ui.dart';

class PuntoApp extends StatelessWidget {
  const PuntoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PuntoStore.instance,
      builder: (context, _) {
        final isDark = PuntoStore.instance.isDarkMode;
        return MaterialApp(
          title: 'PUNTO – Score Keeper',
          debugShowCheckedModeBanner: false,
          theme: buildPuntoTheme(Brightness.light),
          darkTheme: buildPuntoTheme(Brightness.dark),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
