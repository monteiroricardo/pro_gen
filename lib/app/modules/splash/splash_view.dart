import 'package:flutter/material.dart';
import 'package:pro_gen/app/modules/home/cubits/mock_cubit.dart';
import 'package:pro_gen/app/routes/routes_consts.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) async {
        await context.read<MockCubit>().readProducts();
        Navigator.pushNamed(context, RoutesConsts.kHomeView);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(
          0xffFA5A2A,
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              Colors.white,
            ),
          ),
        ));
  }
}
