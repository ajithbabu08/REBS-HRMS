import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebs_hrms/core/widgets/sync_status_badge.dart';

void main() {
  group('SyncStatusBadge Widget Tests', () {
    testWidgets('displays Pending Sync badge correctly with orange background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SyncStatusBadge(status: 'PENDING'),
          ),
        ),
      );

      expect(find.text('Pending Sync'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
    });

    testWidgets('displays Synced badge correctly with green indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SyncStatusBadge(status: 'SYNCED'),
          ),
        ),
      );

      expect(find.text('Synced'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays Rejected badge correctly with error indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SyncStatusBadge(status: 'REJECTED'),
          ),
        ),
      );

      expect(find.text('Rejected'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
