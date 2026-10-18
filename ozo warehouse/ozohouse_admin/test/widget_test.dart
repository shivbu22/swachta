import 'package:flutter_test/flutter_test.dart';
import 'package:ozohouse_admin/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const OzohouseAdminApp());
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
