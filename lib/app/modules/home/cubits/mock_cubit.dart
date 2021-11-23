import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pro_gen/app/models/product_model.dart';
import 'package:pro_gen/app/services/mock_service.dart';
import 'package:pro_gen/app/ui/messages/messages.dart';

class MockCubit extends Cubit<List<ProductModel>> {
  MockCubit() : super([]);

  int? _updateID;

  final _mockService = MockService();

  final nameControl = TextEditingController();

  final priceControl =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  final discountControl =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  final percentageControl = TextEditingController();

  void clearInputs() {
    nameControl.clear();
    priceControl.updateValue(0.0);
    discountControl.updateValue(0.0);
    percentageControl.text = '0';
  }

  bool isNullValidate(MoneyMaskedTextController controller) {
    if (controller.numberValue == 0) {
      return true;
    } else {
      return false;
    }
  }

  double? percentageValidate() {
    if (percentageControl.text == '0' ||
        percentageControl.text == '0.0' ||
        percentageControl.text.isEmpty) {
      return null;
    } else {
      return double.parse(percentageControl.text);
    }
  }

  void calculatePercentageForDiscount() {
    if (double.parse(percentageControl.text) == 100) {
      discountControl.updateValue(priceControl.numberValue);
    } else {
      if (double.parse(percentageControl.text) > 100) {
        percentageControl.text = '100';
      }
      discountControl.updateValue(
        priceControl.numberValue -
            ((priceControl.numberValue * double.parse(percentageControl.text)) /
                100),
      );
    }
  }

  void calculateDiscountForPercentage() {
    if (priceControl.numberValue < discountControl.numberValue) {
      percentageControl.text = '';
    } else {
      double value = priceControl.numberValue - discountControl.numberValue;
      percentageControl.text =
          ((value * 100) / priceControl.numberValue).toStringAsFixed(0);
    }
  }

  bool isAvailable = true;

  void updateInputProduct(ProductModel product) {
    _updateID = product.id;
    nameControl.text = product.name;
    priceControl.updateValue(product.price);
    discountControl.updateValue(product.discount ?? 0.0);
    percentageControl.text =
        product.percentage != null ? product.percentage.toString() : '0';
  }

  Future<void> readProducts() async {
    emit(await _mockService.readProducts());
  }

  Future<void> serchProducts(String search) async {
    emit(await _mockService.searchProducts(search));
  }

  Future<void> createProduct() async {
    try {
      await _mockService.createProduct(
        ProductModel(
          name: nameControl.text,
          price: priceControl.numberValue,
          discount: isNullValidate(discountControl)
              ? null
              : discountControl.numberValue,
          percentage: percentageValidate(),
          isAvailable: isAvailable,
        ),
      );
      Messages.showMessage(MessageType.success,
          message: 'Sucesso ao criar produto');
    } catch (e) {
      Messages.showMessage(MessageType.error,
          message: 'Houve um erro ao criar produto');
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await _mockService.deleteProduct(productId);
      Messages.showMessage(MessageType.success,
          message: 'Sucesso ao deletar produto');
    } catch (e) {
      Messages.showMessage(MessageType.error,
          message: 'Houve um erro ao deletar produto');
    }
  }

  Future<void> updateProduct() async {
    try {
      await _mockService.updateProduct(
        ProductModel(
          id: _updateID,
          name: nameControl.text,
          price: priceControl.numberValue,
          discount: isNullValidate(discountControl)
              ? null
              : discountControl.numberValue,
          percentage: percentageValidate(),
          isAvailable: isAvailable,
        ),
      );
      Messages.showMessage(MessageType.success,
          message: 'Sucesso ao editar produto');
    } catch (e) {
      Messages.showMessage(MessageType.error,
          message: 'Houve um erro ao editar produto');
    }
  }
}
