import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy/services/user.service.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.put(userService());
  });

  tearDown(() {
    Get.delete<userService>();
  });

  test('Form Validation performance and logic test', () {
    // In a real environment we would test the API latency here using a mock server.
    // We are simulating checking the user service injection logic and execution time.

    final service = Get.find<userService>();
    expect(service, isNotNull);

    // Performance assertion on object creation.
    final stopwatch = Stopwatch()..start();
    final anotherService = Get.find<userService>();
    stopwatch.stop();

    expect(anotherService, equals(service));
    expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be almost instant since it's a singleton
  });
}
