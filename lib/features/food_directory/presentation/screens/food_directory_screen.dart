// lib/features/food_directory/presentation/screens/food_directory_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/services/banner_ad_widget.dart';
import 'package:rafiqah/core/widgets/empty_state.dart';
import 'package:rafiqah/features/food_directory/presentation/providers/food_providers.dart';

class FoodDirectoryScreen extends ConsumerStatefulWidget {
  const FoodDirectoryScreen({super.key});

  @override
  ConsumerState<FoodDirectoryScreen> createState() =>
      _FoodDirectoryScreenState();
}

class _FoodDirectoryScreenState extends ConsumerState<FoodDirectoryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _color(int level) => switch (level) {
        1 => AppColors.success,
        2 => AppColors.warning,
        3 => AppColors.error,
        _ => AppColors.primary,
      };

  String _label(int level) => switch (level) {
        1 => 'آمن',
        2 => 'بحذر',
        3 => 'ممنوع',
        _ => 'غير محدد',
      };

  IconData _icon(int level) => switch (level) {
        1 => Icons.check_circle,
        2 => Icons.warning_amber_rounded,
        3 => Icons.cancel,
        _ => Icons.help_outline,
      };

  Future<void> _reseed() async {
    try {
      await ref.read(databaseProvider).ensureFoodSeeded();
      ref.invalidate(foodListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحميل دليل الأغذية')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر تحميل الدليل: $e')),
      );
    }
  }

  void _showDetails(FoodDirectoryData food) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    food.nameArabic,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                ),
                Chip(
                  avatar: Icon(
                    _icon(food.safetyLevel),
                    color: _color(food.safetyLevel),
                    size: 18,
                  ),
                  label: Text(_label(food.safetyLevel)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              food.category,
              style: TextStyle(color: Theme.of(ctx).colorScheme.outline),
            ),
            const SizedBox(height: 16),
            _DetailSection(title: 'السبب الطبي', body: food.reasonMedical),
            _DetailSection(
              title: 'أثناء الحمل',
              body: food.pregnancyAdvice,
            ),
            _DetailSection(
              title: 'بعد الولادة',
              body: food.postpartumAdvice,
            ),
            const SizedBox(height: 8),
            const Text(
              'هذه المعلومات إرشادية عامة ولا تستبدل استشارة الطبيبة أو '
              'أخصائية التغذية، خصوصًا مع وجود حالة صحية أو حساسية.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(foodListProvider);
    final query = ref.watch(foodSearchQueryProvider);
    final filter = ref.watch(foodFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('دليل الأغذية')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'ابحث عن صنف...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'مسح البحث',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          ref.read(foodSearchQueryProvider.notifier).clear();
                        },
                      ),
              ),
              onChanged: (value) =>
                  ref.read(foodSearchQueryProvider.notifier).updateQuery(value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'الكل',
                  selected: filter == null,
                  onSelected: () => ref
                      .read(foodFilterProvider.notifier)
                      .setFilter(null),
                ),
                _FilterChip(
                  label: 'آمن',
                  selected: filter == 1,
                  color: AppColors.success,
                  onSelected: () =>
                      ref.read(foodFilterProvider.notifier).setFilter(1),
                ),
                _FilterChip(
                  label: 'بحذر',
                  selected: filter == 2,
                  color: AppColors.warning,
                  onSelected: () =>
                      ref.read(foodFilterProvider.notifier).setFilter(2),
                ),
                _FilterChip(
                  label: 'ممنوع',
                  selected: filter == 3,
                  color: AppColors.error,
                  onSelected: () =>
                      ref.read(foodFilterProvider.notifier).setFilter(3),
                ),
              ],
            ),
          ),
          Expanded(
            child: foods.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline,
                message: 'تعذر تحميل دليل الأغذية:\n$e',
                action: ElevatedButton(
                  onPressed: _reseed,
                  child: const Text('إعادة المحاولة'),
                ),
              ),
              data: (list) {
                if (list.isEmpty) {
                  if (query.isEmpty && filter == null) {
                    return EmptyState(
                      icon: Icons.restaurant_menu,
                      message: 'دليل الأغذية فارغ. حاولي إعادة تحميله.',
                      action: ElevatedButton(
                        onPressed: _reseed,
                        child: const Text('تحميل الدليل'),
                      ),
                    );
                  }
                  return EmptyState(
                    icon: Icons.search_off,
                    message: 'لا توجد نتائج مطابقة.',
                    action: TextButton(
                      onPressed: () {
                        _controller.clear();
                        ref.read(foodSearchQueryProvider.notifier).clear();
                        ref.read(foodFilterProvider.notifier).setFilter(null);
                      },
                      child: const Text('مسح البحث والفلتر'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final food = list[i];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          _icon(food.safetyLevel),
                          color: _color(food.safetyLevel),
                        ),
                        title: Text(food.nameArabic),
                        subtitle: Text(food.category),
                        trailing: Text(
                          _label(food.safetyLevel),
                          style: TextStyle(
                            color: _color(food.safetyLevel),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => _showDetails(food),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: color ?? AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : null,
          fontWeight: selected ? FontWeight.bold : null,
        ),
        side: color == null ? null : BorderSide(color: color!),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }
}
