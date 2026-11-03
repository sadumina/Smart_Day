import 'package:flutter_test/flutter_test.dart';

import 'package:prod/frontend/app.dart';

void main() {
  testWidgets('shows setup instructions without Supabase configuration',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MissingConfigurationApp());

    expect(find.textContaining('Supabase is not configured'), findsOneWidget);
  });
}
