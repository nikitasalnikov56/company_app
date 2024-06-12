import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/api/api.dart';
import 'package:flutter_application_1/domain/contollers/app_controllers.dart';
import 'package:flutter_application_1/domain/providers/user_provider.dart';
import 'package:flutter_application_1/ui/routes/app_routes.dart';
import 'package:flutter_application_1/ui/style/app_colors.dart';
import 'package:flutter_application_1/ui/style/app_style.dart';
import 'package:flutter_application_1/ui/widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

class SingInBody extends StatelessWidget {
  const SingInBody({super.key, required this.callback});
  final Function callback;
  @override
  Widget build(BuildContext context) {
     final authService = Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Вход',
              style: AppStyle.fontStyle,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Email',
              controller: AppControllers.emailController,
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              labelText: 'Пароль',
              controller: AppControllers.passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                final success = await Api.login(context);
                if (success) {
                  authService.login();
                  context.router.replace(const HomeRoute());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
              ),
              child: Text(
                'Войти',
                style: AppStyle.fontStyle.copyWith(
                  fontSize: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  callback();
                },
                child: Text(
                  'Регистрация',
                  style: AppStyle.fontStyle.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
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
