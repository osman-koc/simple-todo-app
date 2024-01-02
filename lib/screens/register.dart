import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/constants/app_lang.dart';
import 'package:simpletodo/constants/colors.dart';
import 'package:simpletodo/lang/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List socialImages = [
      AppAssets.googleLogo,
      AppAssets.twitterLogo,
      AppAssets.facebookLogo
    ];

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
            signupWithAppRichText(context),
            loginWithAppWrap(socialImages),
            SizedBox(height: screenHeight * 0.03),
            backToLoginText(context),
          ],
        ),
      ),
    );
  }

  RichText backToLoginText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context).translate(key: AppLang.backToLogin),
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.pop(context);
          },
      ),
    );
  }

  Wrap loginWithAppWrap(List<dynamic> socialImages) {
    return Wrap(
      children: List<Widget>.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage(socialImages[index]),
            ),
          ),
        ),
      ),
    );
  }

  RichText signupWithAppRichText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context)
            .translate(key: AppLang.signupWithAppText),
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
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
          AppLocalizations.of(context).translate(key: AppLang.signupButtonText),
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
          const SizedBox(height: 50),
          emailContainer(),
          const SizedBox(height: 20),
          passwordContainer(),
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
            prefixIcon:
                const Icon(Icons.password, color: tdDeepOrangeAccent),
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
            backgroundImage: AssetImage(AppAssets.profileImg),
          ),
        ],
      ),
    );
  }
}
