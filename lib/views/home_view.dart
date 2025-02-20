import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo/gen/assets.gen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Localizations.localeOf(context).toString();
    const envValue = String.fromEnvironment('testValue');
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).helloWorld),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.yMEd().format(DateTime.now()),
            ),
            Image.asset('assets/images/test.png'),
            Assets.images.testPng.image(),
            Assets.images.testSvg.svg(width: 100, height: 100),
            Text('環境変数テスト: $envValue'),
          ],
        ),
      ),
    );
  }
}
