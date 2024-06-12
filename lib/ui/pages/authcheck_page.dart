import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuth(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error checking authentication'),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
    Future<bool> checkAuth(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      context.router.replace(const HomeRoute());
      return true;
    } else {
      context.router.replace(const RegisterRoute());
      return false;
    }
  }
}
