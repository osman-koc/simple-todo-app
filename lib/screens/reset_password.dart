import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/extensions/app_lang.dart';
import 'package:simpletodo/constants/colors.dart';
import 'package:simpletodo/helpers/user_helper.dart';
import 'package:simpletodo/screens/splash.dart';
import 'package:simpletodo/util/toaster.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? _userMail;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            headerContainer(screenWidth, screenHeight),
            inputsContainer(screenWidth, context),
            const SizedBox(height: 50),
            resetBtnContainer(screenWidth, screenHeight, context),
            SizedBox(height: screenHeight * 0.07),
            backToLoginText(context),
          ],
        ),
      ),
    );
  }

  RichText backToLoginText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: context.translate.backToLogin,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.pop(context);
          },
      ),
    );
  }

  Widget resetBtnContainer(
      double screenWidth, double screenHeight, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (UserHelper.isValidEmail(_userMail)) {
          ConstToast.error(context.translate.invalidEmail);
        } else {
          _passwordReset().then((r) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          }).catchError((e) {
            if (kDebugMode) {
              print(e);
            }
          });
        }
      },
      child: Container(
        width: screenWidth * 0.5,
        height: screenHeight * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
            image: AssetImage(AppAssets.loginBtn),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            context.translate.send,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Container inputsContainer(double screenWidth, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          emailContainer(),
        ],
      ),
    );
  }

  Container emailContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(1, 1),
            color: Colors.grey.withOpacity(0.3),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: context.translate.email,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.email, color: tdDeepOrangeAccent),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) => _userMail = value,
      ),
    );
  }

  Text headerText(BuildContext context) {
    return Text(
      context.translate.passwordResetHeaderText,
      style: const TextStyle(
        fontSize: 40,
        fontFamily: AppFontStyles.freestyleScript,
      ),
    );
  }

  Container headerContainer(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.3,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.signUpHeader),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.16),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white70,
            backgroundImage: AssetImage(AppAssets.profileForgotImg),
          ),
        ],
      ),
    );
  }

  Future _passwordReset() async => _handlePasswordReset()
          .then((r) => ConstToast.success(context.translate.successSendMail))
          .catchError((e) {
        ConstToast.error(context.translate.userNotSaved);
        return null;
      });

  Future _handlePasswordReset() async {
    var email = _userMail!.trim();
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
  }
}
