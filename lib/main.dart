import 'package:credit_card_project/Auth/LoginPage.dart';
import 'package:credit_card_project/Onboarding/OnboardingSlider.dart';

import './credit_cards_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Cards Project',
      theme: ThemeData(fontFamily: 'Lato'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: OnboardingSlider()),
      ),
    );
  }
}
