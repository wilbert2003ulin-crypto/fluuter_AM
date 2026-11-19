import 'package:flutter_test/flutter_test.dart';
import 'package:crediruta_app/main.dart';

void main() {
  testWidgets('Carga la pantalla de login de YEYPE\'S NATURA', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CrediRutaApp());

    expect(find.text("YEYPE'S"), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
