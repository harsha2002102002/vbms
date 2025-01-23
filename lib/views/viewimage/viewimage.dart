import 'dart:convert';

import 'package:vbms/controllers/viewimage/viewimagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewImageController>(
      init: ViewImageController(),
      builder: (vi) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
            title: const Text(
              "View Attachment",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // centerTitle: true,
            backgroundColor: Colors.purple,
            iconTheme: const IconThemeData(color: Colors.white, size: 35),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.memory(
                  base64Decode(vi.argumentData.toString()),
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                )),
          ),
        );
      },
    );
  }
}
