import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controller/page1 controller.dart';

var controller = Get.put(DataBaseController());
GlobalKey<FormState> formKey = GlobalKey();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Budget Tracker',
          style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.055,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xff1d1f21),
        leading: const Icon(Icons.menu, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: Obx(
            () =>
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.getCatagoryWiseRecords(1);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: w * 0.32,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Total Income',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${controller.totalIncome}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.06,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.getCatagoryWiseRecords(0);
                        },
                        child: Container(
                          width: w * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Text(
                                'Total Income',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${controller.totalExpense}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.06,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.getRecord();
                        },
                        child: Container(
                          width: w * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Text(
                                'Total Balance',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${controller.totalIncome.value -
                                    controller.totalExpense.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.06,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 0.05,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) =>
                        Card(
                          color: controller.data[index]['isIncome'] == 1
                              ? Colors.green
                              : Colors.red,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(File(controller
                                  .data[index]['img'])),
                            ),
                            title: Text(
                              controller.data[index]['amount'].toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              controller.data[index]['category'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showUpdateDialog(context, index);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller
                                        .deleteRecord(
                                        controller.data[index]['id']);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        backgroundColor: const Color(0xff1d1f21),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text(
              'Update details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                       ImagePicker imagePicker = ImagePicker();
                       controller.xFileImage.value = await imagePicker.pickImage(source: ImageSource.gallery);
                       controller.pickImage();
                      },
                      child: Obx(
                        () => CircleAvatar(
                            radius: 32,
                            backgroundImage: controller.fileImage.value != null
                                ? FileImage(File(controller.fileImage.value!.path),) : null,
                        ),
                      ),
                    ),
                    buildTextFormField(
                      label: 'Amount',
                      controller: controller.txtAmount,
                    ),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      label: 'Category',
                      controller: controller.txtCategory,
                    ),
                    Obx(
                          () =>
                          SwitchListTile(
                            activeTrackColor: Colors.green,
                            title: const Text('Income',
                                style:
                                TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            value: controller.isIncome.value,
                            onChanged: (value) {
                              controller.setIsIncome(value);
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  bool response = formKey.currentState!.validate();
                  if (response) {
                    controller.updateRecord(
                      controller.data[index]['id'],
                      double.parse(controller.txtAmount.text),
                      controller.isIncome.value ? 1 : 0,
                      controller.txtCategory.text,
                      controller.fileImage.value!.path,
                    );
                  }
                  Get.back();
                  controller.txtAmount.clear();
                  controller.txtCategory.clear();
                  controller.isIncome.value = false;
                  },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddDialog(BuildContext context) {
    controller.fileImage.value = null;
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text(
              'Add details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        controller.xFileImage.value = await imagePicker.pickImage(source: ImageSource.gallery);
                        controller.pickImage();
                      },
                      child: Obx(
                            () => CircleAvatar(
                          radius: 32,
                          backgroundImage: controller.fileImage.value != null
                              ? FileImage(File(controller.fileImage.value!.path),) : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    buildTextFormField(
                      label: 'Amount',
                      controller: controller.txtAmount,
                    ),
                    const SizedBox(height: 10),
                    buildTextFormField(
                      label: 'Category',
                      controller: controller.txtCategory,
                    ),
                    Obx(
                          () =>
                          SwitchListTile(
                            activeTrackColor: Colors.green,
                            title: const Text('Income',
                                style:
                                TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            value: controller.isIncome.value,
                            onChanged: (value) {
                              controller.setIsIncome(value);
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  bool response = formKey.currentState!.validate();
                  if (response) {
                    controller.initRecord(
                      double.parse(controller.txtAmount.text),
                      controller.isIncome.value ? 1 : 0,
                      controller.txtCategory.text,
                      controller.fileImage.value!.path,
                    );
                  }
                  Get.back();
                  controller.txtAmount.clear();
                  controller.txtCategory.clear();
                  controller.isIncome.value = false;
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
    );
  }

  TextFormField buildTextFormField({
    required String label,
    required var controller,
  }) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        } else {
          return null;
        }
      },
      cursorColor: Colors.grey,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}
