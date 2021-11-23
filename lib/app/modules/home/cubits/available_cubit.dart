import 'package:flutter_bloc/flutter_bloc.dart';

class AvailableCubit extends Cubit<bool> {
  AvailableCubit() : super(true);

  void setAvailable(bool value) => emit(value);
}
