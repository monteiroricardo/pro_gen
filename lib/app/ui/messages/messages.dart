import 'package:flutter/material.dart';
import '../../../main.dart';

class Messages {
  static void showMessage(MessageType type, {String? message}) {
    applicationScaffoldKey.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: type == MessageType.error
            ? Colors.redAccent[400]!.withOpacity(0.9)
            : Colors.greenAccent[400]!.withOpacity(0.9),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == MessageType.error ? 'Erro' : 'Sucesso',
              style: const TextStyle(
                fontFamily: 'Poppins-SemiBold',
                fontSize: 15.5,
                color: Colors.white,
              ),
            ),
            Text(
              message ??
                  (type == MessageType.error
                      ? 'Um erro inesperado ocorreu'
                      : 'Operação realizada com sucesso'),
              style: const TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MessageType { error, success }
