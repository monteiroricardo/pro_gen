import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pro_gen/app/models/product_model.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback openModal;
  const ProductItemWidget({
    Key? key,
    required this.product,
    required this.openModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 5,
            right: 5,
            top: 10,
            bottom: 10,
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.05,
                ),
                blurRadius: 2,
                spreadRadius: 1.5,
              )
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      child: const Icon(
                        FontAwesome5.image,
                        color: Colors.black26,
                      ),
                    ),
                    product.percentage != null
                        ? Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(
                                0xffFA5A2A,
                              ),
                            ),
                            child: Text(
                              '-%' + product.percentage!.toStringAsFixed(0),
                              style: const TextStyle(
                                fontFamily: 'Poppins-Regular',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'R\$ ',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: product.discount != null
                                ? product.discount!.toStringAsFixed(2)
                                : product.price.toStringAsFixed(2),
                            style: TextStyle(
                              fontFamily: 'Poppins-SemiBold',
                              color: Colors.black.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => openModal(),
                    iconSize: 20,
                    icon: Icon(
                      Icons.mode_edit,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              product.discount != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product.price.toStringAsFixed(2),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 0.7,
                          fontFamily: 'Poppins-Regular',
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        Visibility(
          visible: !product.isAvailable,
          child: InkWell(
            onTap: () => openModal(),
            child: Container(
              margin: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 10,
                bottom: 10,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(
                  0.4,
                ),
              ),
              child: const Center(
                  child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'INDISPONÍVEL',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    color: Colors.white,
                  ),
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
