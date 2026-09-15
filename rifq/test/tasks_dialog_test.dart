import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rifq/screens/add_pill_screen.dart';
import 'package:rifq/screens/add_visit_screen.dart';
import 'package:rifq/screens/tasks_screen.dart';
import 'package:rifq/services/pill_service.dart';
import 'package:rifq/services/visit_service.dart';

void main() {
  testWidgets('AddPillScreen renders as MD3 Dialog and adds pill', (tester) async {
    final pillService = PillService();
    final initialCount = pillService.getPills().length;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AddPillScreen.show(context, pillService: pillService),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog elements exist
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Add Pill'), findsAtLeastNWidgets(1));
    expect(find.text('Pill Name'), findsOneWidget);
    expect(find.text('Dosage'), findsOneWidget);
    expect(find.text('Number of Tablets'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);

    // Fill form
    await tester.enterText(find.widgetWithText(TextFormField, 'Pill Name'), 'Amoxicillin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Dosage'), '250mg');
    await tester.enterText(find.widgetWithText(TextFormField, 'Number of Tablets'), '1');
    await tester.enterText(find.widgetWithText(TextFormField, 'Time'), '09:00 AM');

    // Tap Add Pill
    await tester.tap(find.widgetWithText(FilledButton, 'Add Pill'));
    await tester.pumpAndSettle();

    // Verify dialog dismissed and pill added
    expect(find.byType(Dialog), findsNothing);
    expect(pillService.getPills().length, initialCount + 1);
    expect(pillService.getPills().last.pillName, 'Amoxicillin');
  });

  testWidgets('AddVisitScreen renders as MD3 Dialog and adds visit', (tester) async {
    final visitService = VisitService();
    final initialCount = visitService.getVisits().length;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AddVisitScreen.show(context, visitService: visitService),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog elements exist
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Add Visit'), findsAtLeastNWidgets(1));
    expect(find.text('Visit Name'), findsOneWidget);
    expect(find.text('Doctor Name'), findsOneWidget);
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);

    // Fill form
    await tester.enterText(find.widgetWithText(TextFormField, 'Visit Name'), 'Cardiology Follow-up');
    await tester.enterText(find.widgetWithText(TextFormField, 'Doctor Name'), 'Dr. Adams');
    await tester.enterText(find.widgetWithText(TextFormField, 'Day'), '15');
    await tester.enterText(find.widgetWithText(TextFormField, 'Month'), 'OCT');
    await tester.enterText(find.widgetWithText(TextFormField, 'Time'), '11:00 AM');

    // Tap Add Visit
    await tester.tap(find.widgetWithText(FilledButton, 'Add Visit'));
    await tester.pumpAndSettle();

    // Verify dialog dismissed and visit added
    expect(find.byType(Dialog), findsNothing);
    expect(visitService.getVisits().length, initialCount + 1);
    expect(visitService.getVisits().last.visitName, 'Cardiology Follow-up');
  });

  testWidgets('TasksScreen FAB bottom sheet opens Add Pill and Add Visit dialogs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const TasksScreen(),
      ),
    );

    // Open FAB bottom sheet
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Tap Add Pill tile
    await tester.tap(find.widgetWithText(ListTile, 'Add Pill'));
    await tester.pumpAndSettle();

    // Verify Add Pill dialog is open
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Add a new prescribed medication'), findsOneWidget);

    // Cancel dialog
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);

    // Open FAB bottom sheet again
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Tap Add Visit tile
    await tester.tap(find.widgetWithText(ListTile, 'Add Visit'));
    await tester.pumpAndSettle();

    // Verify Add Visit dialog is open
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Add a new scheduled visit'), findsOneWidget);

    // Close via close icon
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });
}

