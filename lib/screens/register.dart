import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/constants/app_lang.dart';
import 'package:simpletodo/constants/colors.dart';
import 'package:simpletodo/screens/home.dart';
import 'package:simpletodo/util/localization.dart';
import 'package:simpletodo/util/toaster.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  String? _userMail, _userPassword;

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
            registerBtnContainer(screenWidth, screenHeight, context),
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

  Widget registerBtnContainer(
      double screenWidth, double screenHeight, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_userMail == null || _userMail!.length <= 5) {
          ConstToast.error(AppLocalizations.of(context)
              .translate(key: AppLang.invalidEmail));
        } else if (_userPassword == null || _userPassword!.length <= 6) {
          ConstToast.error(AppLocalizations.of(context)
              .translate(key: AppLang.invalidPassword));
        } else {
          _signUpUser().then((user) {
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
            AppLocalizations.of(context)
                .translate(key: AppLang.signupButtonText),
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
          hintText: AppLocalizations.of(context).translate(key: AppLang.email),
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
          prefixIcon: const Icon(Icons.password, color: tdDeepOrangeAccent),
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
        onChanged: (value) => _userPassword = value,
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

  Future<User?> _signUpUser() async => _handleSignIn().catchError((e) {
        ConstToast.error(
            AppLocalizations.of(context).translate(key: AppLang.userNotSaved));
        return null;
      });

  Future<User?> _handleSignIn() async {
    var email = _userMail!.trim();
    var password = _userPassword!;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }
}
