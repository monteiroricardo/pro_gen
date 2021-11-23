import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_gen/app/modules/home/cubits/available_cubit.dart';
import 'package:pro_gen/app/routes/routes_consts.dart';
import 'package:pro_gen/app/routes/routes_paths.dart';
import 'package:pro_gen/app/ui/loader/loader.dart';
import 'package:pro_gen/app/ui/loader/loader_cubit.dart';

import 'app/modules/home/cubits/mock_cubit.dart';

final applicationScaffoldKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MockCubit(),
        ),
        BlocProvider(
          create: (_) => AvailableCubit(),
        ),
        BlocProvider(
          create: (_) => LoaderCubit(),
        )
      ],
      child: Stack(
        alignment: Alignment.center,
        children: [
          MaterialApp(
            scaffoldMessengerKey: applicationScaffoldKey,
            debugShowCheckedModeBanner: false,
            routes: RoutesPaths.paths,
            initialRoute: RoutesConsts.kSplashView,
          ),
          const Loader()
        ],
      ),
    ),
  );
}
