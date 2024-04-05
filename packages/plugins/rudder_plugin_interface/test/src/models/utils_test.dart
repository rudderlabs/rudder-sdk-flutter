import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/utils.dart';

void main() {
  test('conversion of datestring object to string in format YY-MM-dd', () {
    final DateTime date = DateTime(2020, 12, 12);
    expect(Utils.toDateString(date), equals("20-12-12"));
    final DateTime date2 = DateTime(2022, 7, 25);
    expect(Utils.toDateString(date2), equals("22-07-25"));
    final DateTime date3 = DateTime(2023, 1, 13);
    expect(Utils.toDateString(date3), equals("23-01-13"));
    final DateTime date4 = DateTime(2024, 1, 7);
    expect(Utils.toDateString(date4), equals("24-01-07"));
  });
}
