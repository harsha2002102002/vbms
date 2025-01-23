import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/login/airportadminordriver/airportadminordriverlogincontroller.dart';

class AirportAdminLogin extends StatelessWidget {
  const AirportAdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AirportAdminOrDriverLoginController>(
      init: AirportAdminOrDriverLoginController(),
      builder: (aac) {
        return Scaffold(
          appBar: AppBar(
            // leading: GestureDetector(
            //   onTap: () {
            //     Get.back();
            //   },
            //   child: const Icon(Icons.arrow_back_ios),
            // ),
            title: Text(
              'Login to from',
              style: const TextStyle(color: Color(0xFF2a2a2a), fontSize: 24),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: aac.loginFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: aac.loginEmailIDorMobNo,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Email ID / Mobile No.",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 1.5)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 1.5)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 1.5)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email ID / Mobile No. is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: aac.loginPassword,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 1.5)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 1.5)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 1.5)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              aac.showLoginPassword = !aac.showLoginPassword;
                              aac.update();
                            },
                            child: aac.showLoginPassword
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.purple,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.purple,
                                  ),
                          )),
                      obscureText: aac.showLoginPassword,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        if (aac.loginFormKey.currentState!.validate()) {
                          aac.signApi();
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     height: 50,
                    //     alignment: Alignment.centerRight,
                    //     child: const Text(
                    //       "Forgot Password ?",
                    //       style: TextStyle(
                    //           color: Colors.purple,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
