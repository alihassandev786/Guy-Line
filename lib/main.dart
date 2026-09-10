import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';

import 'data/services/sessionmanager.dart';

Future<void> main() async {
  await SessionManager.init(); // 👈 add this before runApp
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
