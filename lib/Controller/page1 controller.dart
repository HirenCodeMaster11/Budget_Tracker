import 'package:get/get.dart';

import '../Database Helper/helper.dart';

class Page1Controller extends GetxController{

  @override
  void onInit(){
    super.onInit();
    initDb();
  }

  Future initDb() async{
    await DatabaseHelper .databaseHelper.database;
  }

  Future insertRecord() async{
    await DatabaseHelper.databaseHelper.insertData();
  }
}
