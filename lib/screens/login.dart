import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/extensions/app_lang.dart';
import 'package:simpletodo/constants/app_colors.dart';
import 'package:simpletodo/helpers/user_helper.dart';
import 'package:simpletodo/screens/home.dart';
import 'package:simpletodo/screens/register.dart';
import 'package:simpletodo/screens/reset_password.dart';
import 'package:simpletodo/util/toaster.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String? _userMail, _userPassword;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors(context).tdBGColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            headerContainer(screenWidth, screenHeight),
            inputsContainer(screenWidth, context),
            const SizedBox(height: 50),
            loginBtnWidget(screenWidth, screenHeight, context),
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
        text: "${context.translate.dontHaveAnAccount} ",
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 18,
        ),
        children: [
          TextSpan(
            text: context.translate.signup,
            style: TextStyle(
              color: AppColors(context).tdTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
          ),
        ],
      ),
    );
  }

  Widget loginBtnWidget(
      double screenWidth, double screenHeight, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (UserHelper.isValidEmail(_userMail)) {
          ConstToast.error(context.translate.invalidEmail);
        } else if (UserHelper.isValidPassword(_userPassword)) {
          ConstToast.error(context.translate.invalidPassword);
        } else {
          _loginUser().then((user) {
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
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
            context.translate.signinButtonText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors(context).tdBGColor,
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen()),
            );
          },
          child: Text(
            context.translate.forgotPasswordText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  Container emailContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors(context).tdBGColor,
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
          prefixIcon:
              Icon(Icons.email, color: AppColors(context).tdDeepOrangeAccent),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                color: AppColors(context).tdDeepOrangeAccent, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: AppColors(context).tdBGColor, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) => _userMail = value,
      ),
    );
  }

  Container passwordContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors(context).tdBGColor,
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
          hintText: context.translate.password,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.password,
              color: AppColors(context).tdDeepOrangeAccent),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                color: AppColors(context).tdDeepOrangeAccent, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: AppColors(context).tdBGColor, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) => _userPassword = value,
      ),
    );
  }

  Text signSubText(BuildContext context) {
    return Text(
      context.translate.siginSubText,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[500],
      ),
    );
  }

  Text helloText(BuildContext context) {
    return Text(
      context.translate.hello,
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

  Future<User?> _loginUser() async => _handleSignIn().catchError((e) {
        if (kDebugMode) {
          print(e);
        }
        ConstToast.error(context.translate.emailOrPasswordWrong);
        return null;
      });

  Future<User?> _handleSignIn() async {
    var email = _userMail!.trim();
    var password = _userPassword!;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }
}
