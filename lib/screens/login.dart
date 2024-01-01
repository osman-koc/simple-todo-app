import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/constants/app_lang.dart';
import 'package:simpletodo/lang/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
            loginBtnContainer(screenWidth, screenHeight, context),
            SizedBox(height: screenHeight * 0.07),
            signupRichText(context),
          ],
        ),
      ),
    );
  }

  RichText signupRichText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text:
            "${AppLocalizations.of(context).translate(key: AppLang.dontHaveAnAccount)} ",
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 18,
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context).translate(key: AppLang.signup),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container loginBtnContainer(
      double screenWidth, double screenHeight, BuildContext context) {
    return Container(
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
          AppLocalizations.of(context).translate(key: AppLang.signinButtonText),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
          helloText(context),
          signSubText(context),
          const SizedBox(height: 50),
          emailContainer(),
          const SizedBox(height: 20),
          passwordContainer(),
          const SizedBox(height: 20),
          forgotPasswordRow(context),
        ],
      ),
    );
  }

  Row forgotPasswordRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Text(
          AppLocalizations.of(context)
              .translate(key: AppLang.forgotPasswordText),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[500],
          ),
        ),
      ],
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
            hintText:
                AppLocalizations.of(context).translate(key: AppLang.email),
            hintStyle: const TextStyle(color: Colors.grey),
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
            )),
      ),
    );
  }

  Container passwordContainer() {
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
        obscureText: true,
        decoration: InputDecoration(
            hintText:
                AppLocalizations.of(context).translate(key: AppLang.password),
            hintStyle: const TextStyle(color: Colors.grey),
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
            )),
      ),
    );
  }

  Text signSubText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).translate(key: AppLang.siginSubText),
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[500],
      ),
    );
  }

  Text helloText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).translate(key: AppLang.hello),
      style: const TextStyle(
        fontSize: 54,
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
          image: AssetImage(AppAssets.loginImg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
