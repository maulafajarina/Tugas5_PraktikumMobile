import 'package:flutter_test/flutter_test.dart';

import 'package:tugas5/main.dart';

void main() {
  testWidgets('Halaman utama menampilkan nama aplikasi dan menu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FoodApp());

    expect(find.text('Warung Nusantara'), findsOneWidget);
    expect(find.text('Semua Menu'), findsOneWidget);
  });
}