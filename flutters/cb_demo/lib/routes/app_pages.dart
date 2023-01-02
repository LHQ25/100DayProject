import 'package:cb_demo/HomeComponent.dart';
import 'package:cb_demo/auction/binding/globel_auction_binging.dart';
import 'package:cb_demo/auction/presentation/controller/GlobelAuctionController.dart';
import 'package:cb_demo/auction/views/gloabel_auction_view.dart';
import 'package:cb_demo/category/views/GoodsCategoryListView.dart';
import 'package:get/get.dart';
import '../category/binding/GoodsCategoryListBinding.dart';
import 'app_routes.dart';

class AppPages {
  static const home = Routes.home;

  static const cate_goods_list = Routes.cateGoodsList;

  static final routes = [
    GetPage(
      name: home,
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
    GetPage(
        name: cate_goods_list,
        page: () => const GoodsCategoryListView(),
        binding: GoodsCategoryListBinging()),
    GetPage(
        name: Routes.gloabel_auction,
        page: () => GlobelAuctionView(),
        binding: GlobelAuctionBinding())
  ];
}