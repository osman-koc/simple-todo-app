import 'package:flutter/material.dart';
import 'package:simpletodo/extensions/app_lang.dart';

class AboutScreenPopup extends StatelessWidget {
  const AboutScreenPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.translate.aboutAppTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(
              context.translate.appName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Center(
            child: Text(
              'v${context.translate.appVersion}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '${context.translate.developedBy}: ',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              context.translate.appDeveloper,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '${context.translate.contact}: ',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              context.translate.appWebsite,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 3),
          Center(
            child: Text(
              context.translate.appMail,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.translate.close),
        ),
      ],
    );
  }
}
