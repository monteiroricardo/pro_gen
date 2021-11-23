import 'package:flutter/cupertino.dart';
import 'package:pro_gen/app/modules/home/home_view.dart';
import 'package:pro_gen/app/modules/splash/splash_view.dart';
import 'package:pro_gen/app/routes/routes_consts.dart';

class RoutesPaths {
  static Map<String, Widget Function(BuildContext)> paths = {
    RoutesConsts.kSplashView: (_) => const SplashView(),
    RoutesConsts.kHomeView: (_) => const HomeView(),
  };
}
