import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_colors.dart';
import 'package:simpletodo/extensions/app_lang.dart';
import 'package:simpletodo/popup/about.dart';
import 'package:simpletodo/screens/splash.dart';
import 'package:simpletodo/util/toaster.dart';

class SideMenu extends StatefulWidget {
  final User currentUser;
  const SideMenu({super.key, required this.currentUser});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.grey[800],
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 52,
                  backgroundImage: AssetImage(AppAssets.defaultUserAvatarOrange),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.currentUser.displayName ?? "",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  widget.currentUser.email ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(context.translate.home),
            onTap: () => Navigator.pop(context),
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => const HomeScreen(),
            //   ),
            // ),
          ),
          ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.translate.about),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AboutScreenPopup();
                  },
                );
              }),
          Divider(color: AppColors(context).tdGrey),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(context.translate.logout),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  _logout() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            ))
        .catchError((error) => ConstToast.error(context.translate.errorLogout));
  }
}
