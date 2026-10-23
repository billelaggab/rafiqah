// lib/features/mode_selector/presentation/screens/mode_selector_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';
import 'package:rafiqah/features/mode_selector/presentation/providers/app_mode_notifier.dart';

class ModeSelectorScreen extends ConsumerWidget {
  const ModeSelectorScreen({super.key, required this.onSelected});
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختاري وضعك')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: AppMode.values.map((m) {
            return Card(
              child: InkWell(
                onTap: () async {
                  await ref.read(appModeProvider.notifier).setMode(m);
                  onSelected();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.emoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(m.labelAr, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}