import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Database Helper/helper.dart';

class DataBaseController extends GetxController {
  RxList data = [].obs;
  var txtAmount = TextEditingController();
  var txtCategory = TextEditingController();

  RxBool isIncome = false.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;
  Rx<File?> fileImage = Rx<File?>(null);
  Rx<XFile?> xFileImage = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    initDb();
  }

  void setIsIncome(bool value) {
    isIncome.value = value;
  }

  void initDb() async {
    await DatabaseHelper.databaseHelper.database;
  }

  Future<void> initRecord(double amount, int isIncome, String category,String img) async {
    await DatabaseHelper.databaseHelper.insertData(amount, isIncome, category,img);
    await getRecord();
  }

  Future getRecord() async {
    totalIncome.value = 0.0;
    totalExpense.value = 0.0;
    data.value = await DatabaseHelper.databaseHelper.readData();
    print("Data in Controller: ${data.value}");  // Debug print

    for (var check in data) {
      if (check['isIncome'] == 1) {
        totalIncome.value += check['amount'];
      } else {
        totalExpense.value += check['amount'];
      }
    }
    print("Total Income: ${totalIncome.value}, Total Expense: ${totalExpense.value}");  // Debug print
    return data;
  }

  Future<void> updateRecord(
      int id, double amount, int isIncome, String category,String img) async {
    await DatabaseHelper.databaseHelper
        .updateData(id, amount, isIncome, category,img);
    await getRecord();
  }

  Future<void> deleteRecord(int id) async {
    await DatabaseHelper.databaseHelper.deleteData(id);
    await getRecord();
  }

  Future<void> getCatagoryWiseRecords(isIncome)
  async {
    data.value = await DatabaseHelper.databaseHelper.readCatagoryWiseData(isIncome);
  }

  void pickImage(){
    fileImage.value = File(xFileImage.value!.path);
  }
}