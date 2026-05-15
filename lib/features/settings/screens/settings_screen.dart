import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../data/repositories/daily_repository.dart';
import '../../../features/daily_input/providers/daily_input_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          const Text("Appearance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Theme", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text("System"),
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text("Light"),
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text("Dark"),
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (Set<ThemeMode> selected) {
                      ref.read(themeModeProvider.notifier).setThemeMode(selected.first);
                    },
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Data Management Section
          const Text("Data Management", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Clear All Data"),
              subtitle: const Text("Delete all logged entries permanently"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showClearConfirmationDialog(context, ref),
            ),
          ),

          const SizedBox(height: 40),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("NutriSense"),
            subtitle: Text("Version 1.0"),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Data?"),
        content: const Text(
          "This will permanently delete ALL your logged food entries.\n\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(dailyRepositoryProvider);
              await repo.clearAllData();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🗑️ All data cleared successfully"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Clear Everything"),
          ),
        ],
      ),
    );
  }
}