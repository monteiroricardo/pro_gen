import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_gen/app/ui/loader/loader_cubit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderCubit, bool>(
      builder: (ctx, loader) => Visibility(
        visible: loader,
        child: Container(
          color: Colors.black38,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.blueAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
