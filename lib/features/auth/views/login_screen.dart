import 'package:flutter/material.dart';
import 'package:novindus_tets/core/constants/image_constants.dart';

import 'package:novindus_tets/core/constants/text_style_constants.dart';
import 'package:novindus_tets/core/widgets/image_widget.dart';
import 'package:novindus_tets/core/widgets/primary_button.dart';
import 'package:novindus_tets/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:novindus_tets/core/routes/routes.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'package:novindus_tets/core/utils/snackbar_utils.dart';
import 'package:novindus_tets/core/utils/extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'test_user');
  final _passwordController = TextEditingController(text: '12345678');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImageWidget(image: AppImages.loginBg, fit: BoxFit.cover),
                  Center(
                    child: ImageWidget(
                      image: AppImages.logo,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login Or Register to Book \nYour Appointments",
                        style: TextStyleConstants.heading1,
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: _usernameController,
                        label: "Email",
                        hint: "Enter your email",
                        validator: (v) =>
                            v!.isNullOrEmpty ? "Enter a valid email" : null,
                      ),

                      CustomTextField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "Enter your password",
                        validator: (v) => v!.isValidPassword
                            ? null
                            : "Password must be at least 6 characters",
                        isPassword: true,
                      ),
                      const SizedBox(height: 60),

                      Consumer<AuthController>(
                        builder: (context, auth, _) {
                          return PrimaryButton(
                            text: "Login",
                            isLoading: auth.isLoading,
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;
                              final success = await auth.login(
                                _usernameController.text,
                                _passwordController.text,
                              );
                              if (success && context.mounted) {
                                Routes.pushReplacementNamed(Routes.home);
                              } else if (auth.errorMessage != null &&
                                  context.mounted) {
                                SnackbarUtils.showError(auth.errorMessage!);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 26,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyleConstants.bodySmall,
                    children: [
                      TextSpan(
                        text:
                            "By creating or logging into an account you are agreeing \nwith our ",
                      ),
                      TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyleConstants.link,
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy.",
                        style: TextStyleConstants.link,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
