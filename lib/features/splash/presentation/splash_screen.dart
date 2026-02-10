import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus_tets/core/constants/image_constants.dart';
import 'package:novindus_tets/core/widgets/image_widget.dart';
import 'package:novindus_tets/core/routes/routes.dart';
import 'package:novindus_tets/features/auth/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthController>(context, listen: false);
    await authProvider.checkLoginStatus();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      Routes.pushReplacementNamed(Routes.home);
    } else {
      Routes.pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [ImageWidget(image: AppImages.splashBg, fit: BoxFit.cover)],
      ),
    );
  }
}
