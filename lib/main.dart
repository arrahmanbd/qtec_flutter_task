import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/pages/home_page.dart';
import 'package:qtec_flutter_task/src/service_locator.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();
  // Initialize dependencies
  await initializeDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UIConfig(
      frame: Size(360, 800),
      child: MaterialApp(
        title: 'Qtec Task App',
        theme: lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
