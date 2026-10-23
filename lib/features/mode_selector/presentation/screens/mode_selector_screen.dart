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
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.95,
          children: AppMode.values.map((m) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  await ref.read(appModeProvider.notifier).setMode(m);
                  onSelected();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(m.emoji, style: const TextStyle(fontSize: 36))),
                    ),
                    const SizedBox(height: 12),
                    Text(m.labelAr, textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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