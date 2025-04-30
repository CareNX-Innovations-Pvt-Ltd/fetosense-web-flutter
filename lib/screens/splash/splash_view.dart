import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<StatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final prefs = locator<PreferenceHelper>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((onValue) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    if (prefs.getAutoLogin()) {
      _handleAutoLogin();
    } else {
      if(mounted){
        context.goNamed(AppRoutes.login);
      }
    }
  }

  Future<void> _handleAutoLogin() async {
    try {
      if (mounted) {
        context.goNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        context.goNamed(AppRoutes.login);
      }
      debugPrint("Auto-login failed: $e");
    }
  }

  Widget _buildWaitingScreen() {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/images/login/fetosense.png'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWaitingScreen();
  }
}
