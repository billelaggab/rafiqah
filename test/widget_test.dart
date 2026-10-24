// test/widget_test.dart
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/app/app.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';

void main() {
  testWidgets('app shows the medical disclaimer on first launch', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const RafiqahApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(
      find.text('⚠️ تنبيه وإخلاء مسؤولية طبية قانوني'),
      findsOneWidget,
    );
    expect(find.text('أوافق وأتفهم ذلك ✓'), findsOneWidget);
  });
}
