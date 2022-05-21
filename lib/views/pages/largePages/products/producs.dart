import 'package:flutter/material.dart';
import 'package:pos_system/views/pages/largePages/products/all_products.dart';
import 'package:responsive_builder/responsive_builder.dart';


class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop:  AllProduct(gridCtn: 4),
      tablet:   AllProduct(gridCtn: 3),
      mobile:   AllProduct(gridCtn: 2),
      watch:    Container(color:Colors.white),
    );
  }
}
