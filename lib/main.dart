import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy/services/router.service.dart';
import 'package:pharmacy/views/index.dart';
import 'package:pharmacy/services/user.service.dart';
import 'package:pharmacy/services/cache.service.dart';
import 'package:pharmacy/services/realtime.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(CacheService());
  Get.put(RealtimeService());
  Get.put(userService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "MEDZY",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const firstPage(),
      getPages: Routes.routes,
      initialRoute: '/',
    );
  }
}
