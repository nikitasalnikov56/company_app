import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/widgets/register_body.dart';
import 'package:flutter_application_1/ui/widgets/signin_body.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isActive = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isActive
          ? RegisterBody(
              callback: () {
                setState(() {
                  isActive = true;
                });
              },
            )
          : SingInBody(
              callback: () {
                setState(() {
                  isActive = false;
                });
              },
            ),
    );
  }
}
