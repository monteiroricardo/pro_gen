import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_gen/app/helpers/size_helper.dart';
import 'package:pro_gen/app/models/product_model.dart';
import 'package:pro_gen/app/modules/home/cubits/available_cubit.dart';
import 'package:pro_gen/app/modules/home/cubits/mock_cubit.dart';
import 'package:pro_gen/app/modules/home/widgets/app_bar_widget.dart';
import 'package:pro_gen/app/modules/home/widgets/product_item_widget.dart';
import 'package:pro_gen/app/modules/home/widgets/text_field_widget.dart';
import 'package:pro_gen/app/ui/loader/loader_cubit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isAvailable = true;
  @override
  Widget build(BuildContext context) {
    void openNewProductModal() {
      context.read<MockCubit>().clearInputs();
      showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: SizeHelper.height(85, context),
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    20,
                  ),
                ),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          FeatherIcons.x,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      label: 'Nome',
                      controller: context.read<MockCubit>().nameControl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        } else {
                          if (value.length > 30) {
                            return 'Nome maior que 30 caracteres.';
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldWidget(
                      textInputType: TextInputType.number,
                      label: 'Preço',
                      controller: context.read<MockCubit>().priceControl,
                      validator: (value) {
                        if (context
                                .read<MockCubit>()
                                .priceControl
                                .numberValue ==
                            0.0) {
                          return 'Campo obrigatório';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFieldWidget(
                            onChanged: (value) {
                              context
                                  .read<MockCubit>()
                                  .calculateDiscountForPercentage();
                            },
                            textInputType: TextInputType.number,
                            controller:
                                context.read<MockCubit>().discountControl,
                            label: 'Preço Promoção',
                            validator: (value) {
                              if (value == null ||
                                  context
                                          .read<MockCubit>()
                                          .discountControl
                                          .numberValue ==
                                      0.0) {
                                return null;
                              } else {
                                if (context
                                        .read<MockCubit>()
                                        .priceControl
                                        .numberValue <
                                    context
                                        .read<MockCubit>()
                                        .discountControl
                                        .numberValue) {
                                  return 'Inconsistência de informações';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFieldWidget(
                            textInputType: TextInputType.number,
                            controller:
                                context.read<MockCubit>().percentageControl,
                            label: 'Percentual',
                            onChanged: (value) {
                              context
                                  .read<MockCubit>()
                                  .calculatePercentageForDiscount();
                            },
                            validator: (value) {
                              if (value == null ||
                                  context
                                          .read<MockCubit>()
                                          .percentageControl
                                          .text ==
                                      '0' ||
                                  context
                                          .read<MockCubit>()
                                          .percentageControl
                                          .text ==
                                      '0.0' ||
                                  context
                                      .read<MockCubit>()
                                      .percentageControl
                                      .text
                                      .isEmpty) {
                                return null;
                              } else {}
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocBuilder<AvailableCubit, bool>(
                        builder: (ctx, available) => SwitchListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              'Disponível para venda',
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: 13,
                                color: Colors.black.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              'Um produto indisponível não poderá ser comprado pelo seus clientes.',
                              style: TextStyle(
                                height: 0.9,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black.withOpacity(
                                  0.5,
                                ),
                                fontSize: 12,
                              ),
                            ),
                            value: available,
                            onChanged: (value) {
                              context
                                  .read<AvailableCubit>()
                                  .setAvailable(value);
                            }),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          context.read<LoaderCubit>().setLoader(true);
                          context.read<MockCubit>().isAvailable =
                              context.read<AvailableCubit>().state;
                          await context.read<MockCubit>().createProduct();
                          await context.read<MockCubit>().readProducts();
                          Navigator.pop(context);
                          context.read<MockCubit>().clearInputs();
                          context.read<LoaderCubit>().setLoader(false);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(
                            0xffFA5A2A,
                          ),
                        ),
                        child: const Text(
                          'CRIAR',
                          style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    void openEditProductModal(ProductModel product) {
      context.read<AvailableCubit>().setAvailable(product.isAvailable);
      context.read<MockCubit>().updateInputProduct(product);
      showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: SizeHelper.height(85, context),
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    20,
                  ),
                ),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          FeatherIcons.x,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      label: 'Nome',
                      controller: context.read<MockCubit>().nameControl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        } else {
                          if (value.length > 30) {
                            return 'Nome maior que 30 caracteres.';
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldWidget(
                      textInputType: TextInputType.number,
                      label: 'Preço',
                      controller: context.read<MockCubit>().priceControl,
                      validator: (value) {
                        if (context
                                .read<MockCubit>()
                                .priceControl
                                .numberValue ==
                            0.0) {
                          return 'Campo obrigatório';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFieldWidget(
                            onChanged: (value) {
                              context
                                  .read<MockCubit>()
                                  .calculateDiscountForPercentage();
                            },
                            textInputType: TextInputType.number,
                            controller:
                                context.read<MockCubit>().discountControl,
                            label: 'Preço Promoção',
                            validator: (value) {
                              if (value == null ||
                                  context
                                          .read<MockCubit>()
                                          .discountControl
                                          .numberValue ==
                                      0.0) {
                                return null;
                              } else {
                                if (context
                                        .read<MockCubit>()
                                        .priceControl
                                        .numberValue <
                                    context
                                        .read<MockCubit>()
                                        .discountControl
                                        .numberValue) {
                                  return 'Inconsistência de informações';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFieldWidget(
                            textInputType: TextInputType.number,
                            controller:
                                context.read<MockCubit>().percentageControl,
                            label: 'Percentual',
                            onChanged: (value) {
                              context
                                  .read<MockCubit>()
                                  .calculatePercentageForDiscount();
                            },
                            validator: (value) {
                              if (value == null ||
                                  context
                                          .read<MockCubit>()
                                          .percentageControl
                                          .text ==
                                      '0' ||
                                  context
                                          .read<MockCubit>()
                                          .percentageControl
                                          .text ==
                                      '0.0' ||
                                  context
                                      .read<MockCubit>()
                                      .percentageControl
                                      .text
                                      .isEmpty) {
                                return null;
                              } else {}
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocBuilder<AvailableCubit, bool>(
                        builder: (ctx, available) => SwitchListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              'Disponível para venda',
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: 13,
                                color: Colors.black.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              'Um produto indisponível não poderá ser comprado pelo seus clientes.',
                              style: TextStyle(
                                height: 0.9,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black.withOpacity(
                                  0.5,
                                ),
                                fontSize: 12,
                              ),
                            ),
                            value: available,
                            onChanged: (value) {
                              context
                                  .read<AvailableCubit>()
                                  .setAvailable(value);
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              'Excluir produto',
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text:
                                          'Esta ação excluirá permanentemente o produto ',
                                      style: const TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 13,
                                          color: Colors.grey),
                                      children: [
                                        TextSpan(
                                          text: product.name,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Bold',
                                            color:
                                                Colors.black.withOpacity(0.75),
                                          ),
                                        )
                                      ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(
                                              0xffFA5A2A,
                                            )),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          width: double.infinity,
                                          height: 40,
                                          child: const Text(
                                            'VOLTAR',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              color: Color(
                                                0xffFA5A2A,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          context
                                              .read<LoaderCubit>()
                                              .setLoader(true);
                                          await context
                                              .read<MockCubit>()
                                              .deleteProduct(product.id!);
                                          await context
                                              .read<MockCubit>()
                                              .readProducts();
                                          context
                                              .read<LoaderCubit>()
                                              .setLoader(false);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xffFA5A2A,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          width: double.infinity,
                                          height: 40,
                                          child: const Text(
                                            'EXCLUIR',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: const Text(
                          'EXCLUIR',
                          style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            color: Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          context.read<MockCubit>().isAvailable =
                              context.read<AvailableCubit>().state;

                          context.read<LoaderCubit>().setLoader(true);
                          await context.read<MockCubit>().updateProduct();
                          await context.read<MockCubit>().readProducts();
                          Navigator.pop(context);
                          context.read<MockCubit>().clearInputs();
                          context.read<LoaderCubit>().setLoader(false);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(
                            0xffFA5A2A,
                          ),
                        ),
                        child: const Text(
                          'ATUALIZAR',
                          style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.only(top: 2),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(
                  0.05,
                ),
              ),
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Poppins-Regular',
                  color: Colors.black87,
                ),
                onSubmitted: (search) async {
                  context.read<LoaderCubit>().setLoader(true);
                  await context.read<MockCubit>().serchProducts(search);
                  context.read<LoaderCubit>().setLoader(false);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FeatherIcons.search,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            BlocBuilder<MockCubit, List<ProductModel>>(
              builder: (context, list) {
                return Expanded(
                  child: list.isEmpty
                      ? const Center(
                          child: Text(
                            'Nada por aqui :/',
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              color: Colors.black87,
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: list.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisExtent: 280),
                          itemBuilder: (ctx, index) => ProductItemWidget(
                            product: list[index],
                            openModal: () => openEditProductModal(
                              list[index],
                            ),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openNewProductModal(),
        backgroundColor: const Color(
          0xffFA5A2A,
        ),
        label: const Text(
          '+ PRODUTO',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
          ),
        ),
      ),
    );
  }
}
