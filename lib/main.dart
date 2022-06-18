import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/bindings/bindings.dart';
import 'package:pos_system/services/internationalization/messages.dart';
import 'package:pos_system/views/pages/largePages/cash/cash_in_out.dart';
import 'package:pos_system/views/pages/largePages/customer/customer.dart';
import 'package:pos_system/views/pages/largePages/dashboard/dashboard.dart';
import 'package:pos_system/views/pages/largePages/endOfDay/end_of_day.dart';
import 'package:pos_system/views/pages/largePages/login/login.dart';
import 'package:pos_system/views/pages/largePages/printer/print_view.dart';
import 'package:pos_system/views/pages/largePages/products/producs.dart';
import 'package:pos_system/views/pages/largePages/products/product_details.dart';
import 'package:pos_system/views/pages/largePages/profile/profile.dart';
import 'package:pos_system/views/pages/largePages/saleHistory/sale_history.dart';
import 'package:pos_system/views/pages/largePages/secondMonitor/show_factor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS System',
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale("fa", "IR"),
        Locale("ar", "KW"),
        Locale("en", "US"),
      ],
      theme: ThemeData(
        primarySwatch: Colors.teal,
        //fontFamily: 'pelak'
      ),
      defaultTransition: Transition.cupertino,
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/dashboard', page: () => const Dashboard()),
        GetPage(name: '/profile', page: () => const Profile()),
        GetPage(name: '/allProduct', page: () => const Products()),
        GetPage(name: '/productDetails', page: () => const ProductDetails()),
        GetPage(name: '/saleHistory', page: () => const SaleHistory()),
        GetPage(name: '/customers', page: () => const Customer()),
        GetPage(name: '/cashInOut', page: () => const CashInOut()),
        GetPage(name: '/endOfDay', page: () => const EndOfDay()),
        GetPage(name: '/print', page: () => const PrintView()),
        GetPage(name: '/showFactor', page: () => ShowFactor()),
      ],
      initialRoute: '/login',
      initialBinding: AppBindings(),
      unknownRoute: GetPage(name: '/nothingFound', page: () => Login()),
    );
  }
}
