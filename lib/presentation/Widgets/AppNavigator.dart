import 'package:get/get.dart';

class AppNavigator {
  AppNavigator._();

  static Future<T?> pushFade<T>(String page)async {
    return Get.toNamed<T>(page);
  }

  static Future<T?> pushRight<T>(String page) async{
    return Get.toNamed<T>(page);
  }

  static Future<T?> pushLeft<T>(String page) async{
    return Get.toNamed<T>(page);
  }

  static Future<T?> pushUp<T>(String page) async {
    return Get.toNamed<T>(page);
  }

  static Future<T?> pushReplace<T>(String page) async{
    return Get.offNamed<T>(page);
  }

  static Future<T?> pushAndClear<T>(String page) async{
    return Get.offAllNamed<T>(page);
  }
}