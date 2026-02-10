import 'package:flutter/material.dart';
import 'package:novindus_tets/core/utils/snackbar_utils.dart';
import 'package:provider/provider.dart';
import 'package:novindus_tets/core/routes/routes.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/patients/controllers/patient_controller.dart';
import 'features/patients/controllers/patient_registration_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PatientController()),
        ChangeNotifierProvider(create: (_) => PatientRegistrationController()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
        initialRoute: Routes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
