import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../controller/GoodsCategoryListController.dart';

class GoodsCategoryListView extends GetView<GoodsCategoryListController> {

  const GoodsCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("瓷花瓶"),
        titleTextStyle: mediumStyle(fontSize: 18, color: const Color(0xFF222222)),
        automaticallyImplyLeading: false,
        leading: const BackButton(color: Color(0xFF333333),),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Color(0xFF333333),))
        ],
      ),
      backgroundColor: Colors.white,
      body: MasonryGridView.count(crossAxisCount: 2,
        itemCount: 12,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemBuilder: (context, index){
          return Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/cate/cate_test${index % 4}.png", fit: BoxFit.fitWidth,),
              Padding(padding: const EdgeInsets.only(top: 15, bottom: 20), 
                child: Text.rich(
                    maxLines: 2,
                    TextSpan(text: "Lot 1233",
                    style: semiBoldStyle(fontSize: 13, color: const Color(0xFF333333)),

                  children: [
                    TextSpan(text: "：珊瑚红描金云龙纹小花瓢",
                    style: mediumStyle(fontSize: 13, color: const Color(0xFF333333)))]
                )
                ),),
              Text("起拍价：", style: mediumStyle(fontSize: 11, color: const Color(0xFF777777)),),
              Padding(padding: const EdgeInsets.only(top: 3, bottom: 2),
                child: Row(children: [
                  Text("USD 500", style: mediumStyle(fontSize: 12, color: const Color(0xFF111111)),),
                  const Spacer(),
                  SizedBox(width: 20, height: 20,
                  child: ElevatedButton(onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 20),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.zero,
                          backgroundColor: Colors.white, 
                          elevation: 0,
                          splashFactory: NoSplash.splashFactory,
                          surfaceTintColor: Colors.red,
                          disabledForegroundColor: Colors.yellow,
                          shadowColor: Colors.transparent), 
                      child: Image.asset("assets/images/home/home_collect.png", width: 20, height: 20,)
                      ),)
                ],),)
            ],
          );
        }),);
  }
  
}