import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrisense/data/repositories/daily_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';  
import 'core/router.dart';            
import 'data/database/hive_boxes.dart';
import 'features/meal_search/services/search_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveBoxes.init();
  await DailyRepository().getAllEntries();
  await SearchCache.init();   

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'NutriSense',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
    );
  }
}