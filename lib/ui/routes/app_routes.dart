import 'package:auto_route/auto_route.dart';
import 'package:flutter_application_1/ui/pages/authcheck_page.dart';
import 'package:flutter_application_1/ui/pages/home_page.dart';
import 'package:flutter_application_1/ui/pages/register_page.dart';

part 'app_routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
     AutoRoute(page: AuthCheckRoute.page, initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: HomeRoute.page),
  ];
}