import 'package:flutter/material.dart';
import 'package:novindus_tets/features/auth/views/login_screen.dart';
import 'package:novindus_tets/features/patients/views/home_screen.dart';
import 'package:novindus_tets/features/patients/views/register_patient_screen.dart';
import 'package:novindus_tets/features/splash/presentation/splash_screen.dart';
import 'package:novindus_tets/features/patients/views/invoice_page.dart';
import 'package:novindus_tets/features/patients/models/invoice_model.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String invoice = '/invoice';

  static void pushNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pushAndRemoveUntil(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPatientScreen());
      case Routes.invoice:
        final args = settings.arguments as InvoiceModel;
        return MaterialPageRoute(builder: (_) => InvoicePage(model: args));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
