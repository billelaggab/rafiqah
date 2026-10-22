// lib/features/food_directory/presentation/screens/food_directory_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/features/food_directory/presentation/providers/food_providers.dart';
import 'package:rafiqah/core/services/banner_ad_widget.dart';

class FoodDirectoryScreen extends ConsumerWidget {
  const FoodDirectoryScreen({super.key});

  Color _color(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _label(int level) {
    switch (level) {
      case 1:
        return '✅ آمن';
      case 2:
        return '⚠️ بحذر';
      case 3:
        return '🚫 ممنوع';
      default:
        return '?';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = ref.watch(foodListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('دليل الأغذية')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ابحث عن صنف...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => ref.read(foodSearchQueryProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: foods.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (list) => ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final f = list[i];
                  return Card(
                    child: ListTile(
                      title: Text(f.nameArabic),
                      subtitle: Text('${f.category} • ${f.reasonMedical}'),
                      trailing: Text(_label(f.safetyLevel), style: TextStyle(color: _color(f.safetyLevel))),
                    ),
                  );
                },
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}