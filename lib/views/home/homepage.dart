import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/homecontroller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
        init: HomePageController(),
        builder: (hc) => Scaffold(
              body: Container(
                height: Get.height,
                width: Get.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                      Color(0xFFDFD0DF),
                      Color(0xFFDFD0DF),
                    ],
                    begin: Alignment.topLeft, // Start of the gradient
                    end: Alignment.bottomRight, // End of the gradient
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          /*border: Border.all(color: Colors.purple, width: 2)*/
                        ),
                        width: 500,
                        height: 200,
                        child: PageView.builder(
                            controller: hc.pageController,
                            allowImplicitScrolling: true,
                            itemCount: hc.slideImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(hc.slideImages[index]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Image.asset(
                          'assets/gif/bottomhome.gif',
                          scale: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
