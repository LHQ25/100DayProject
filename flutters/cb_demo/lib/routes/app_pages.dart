import 'package:cb_demo/HomeComponent.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static const home = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeComponent(),
      binding: HomeComponentBinding(),
      children: const [
        // GetPage(
        //   name: Routes.COUNTRY,
        //   page: () => CountryView(),
        //   children: [
        //     GetPage(
        //       name: Routes.DETAILS,
        //       page: () => DetailsView(),
        //     ),
        //   ],
        // ),
      ],
    ),
  ];
}
