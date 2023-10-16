import 'package:flutter/material.dart';

/// {@template login_page}
/// SplashPage widget
/// {@endtemplate}
class SplashPage extends StatefulWidget {
  /// {@macro login_page}
  const SplashPage({super.key});

  static const String routeName = 'splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// State for widget SplashPage
class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
