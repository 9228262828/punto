import 'package:flutter/material.dart';

import 'app.dart';
import 'store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PuntoStore.instance.load();
  runApp(const PuntoApp());
}
