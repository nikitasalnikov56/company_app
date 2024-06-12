import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/providers/user_provider.dart';
import 'package:flutter_application_1/ui/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        // home: MyHomePage(),
      ),
    );
  }
}
