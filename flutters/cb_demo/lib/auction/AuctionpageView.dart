import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class AuctionController extends StatefulWidget {
  const AuctionController({super.key});

  @override
  State<AuctionController> createState() => _AuctionControllerState();
}

class _AuctionControllerState extends State<AuctionController> {
  final _images = ["assets/images/banner/1.png", "assets/images/banner/2.png"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
            headerSliverBuilder: (context, value) {
              return _createHeaderView();
            },
            body: ListView()),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                height: 46,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            "assets/images/home/home_appbar_search_bg2.png"))),
                child: Row(
                  children: [Text("data")],
                ),
              ),
            )),
      ],
    );
  }

  List<Widget> _createHeaderView() {
    return [
      SliverToBoxAdapter(
        child: SizedBox(
          width: double.infinity,
          height: 358,
          child: Swiper(
            containerHeight: 358,
            containerWidth: double.infinity,
            autoplay: true,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.fitWidth,
              );
            },
            // indicatorLayout: PageIndicatorLayout.COLOR,
          ),
        ),
      )
    ];
  }
}
