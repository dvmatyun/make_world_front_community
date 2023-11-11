import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';

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
  String _progress = 'Initializing...';
  @override
  void initState() {
    super.initState();
    //_initAsync();
  }

  Future<void> _initAsync() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _progress = 'Fetching user...';
    _setState();
    await Future<void>.delayed(const Duration(seconds: 1));
    _progress = 'Finishing...';
    _setState();
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      await RouterDelegateAim.of(context).setNewRoutePath(const AppConfigAim.route(HomePage.routeName));
    }
  }

  void _setState() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Splash page'),
            const CircularProgressIndicator(),
            Text(_progress),
          ],
        ),
      ),
    );
  }
}
