//
//  ContentView.swift
//  SwiftUIBanner
//
//  Created by 9527 on 2022/7/16.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentIndex = 5
    @State var offset: CGFloat = 0
    @GestureState var dragOffset: CGFloat = 0

    var body: some View {

        /*
         GeometryReader几何容器，将我们的Image图片和Text文字包裹在里面。
         而且图片的大小.frame修饰符中，设置的Image图片尺寸是我们GeometryReader几何容器宽高。
         GeometryReader几何容器简单来说，就是一个View，
         但不同的是，它的宽高是通过自动判断你的设备的屏幕尺寸的定的。
         这样，假设我们有一张4000*4000分辨率的图片的时候，我们就不用再设置它在屏幕中展示的固定大小了，屏幕多少，里面的图片就可以自动设置多大
         */
        GeometryReader { outerView in

            /*
             使用ScrollView滚动视图的方式创建了一个类似Banner轮播图的样式，
             发现ScrollView滚动视图没有分页界限，不知道在哪个位置可以停下，
             ScrollView滚动视图是一整个视图，这样我们也没有办法实现点击单个CardView卡片视图进入它的详情。
             因此，使用ScrollView滚动视图创建Banner轮播图的方法是不对的，至少目前不太可行
             */
//            ScrollView(.horizontal, showsIndicators: false) {

                /*
                    使用HStack横向视图和Gestures手势做一个Banner轮播图
                 */
                HStack(alignment: .center, spacing: 0) {

                    ForEach(imageModels, id: \.id) { (model) in

                        CardView(image: model.image, name: model.imageName)
                                .padding(.horizontal)
                                .frame(width: outerView.size.width, height: imageModels[currentIndex].id == model.id ? 250 : 200)
                                .opacity(imageModels[currentIndex].id == model.id ? 1 : 0.7)

                    }
                }
                        .frame(alignment: .leading)
                        .offset(x: -CGFloat(currentIndex) * outerView.size.width)
                        .offset(x: dragOffset)
                        .gesture(
                                DragGesture()
                                .updating($dragOffset) { (value, state, transaction) in
                                    state = value.translation.width
                                }
                                .onEnded { value in
                                    let threshold = outerView.size.width * 0.65
                                    var newIndex = Int(-value.translation.width / threshold) + currentIndex
                                    debugPrint(newIndex)
                                    newIndex = min(max(newIndex, 0), imageModels.count - 1)
                                    self.currentIndex = newIndex
                                }
                        )
//            }
        }
                .animation(.interpolatingSpring(mass: 0.6, stiffness: 100, damping: 100, initialVelocity: 0.3), value: offset)
    }
}


struct imageModel: Identifiable {
    var id = UUID()
    var image: String
    var imageName: String
}

let imageModels = [
    imageModel(image: "1", imageName: "图片01"),
    imageModel(image: "2", imageName: "图片02"),
    imageModel(image: "3", imageName: "图片03"),
    imageModel(image: "4", imageName: "图片04"),
    imageModel(image: "5", imageName: "图片05"),
    imageModel(image: "6", imageName: "图片06"),
    imageModel(image: "7", imageName: "图片07"),
    imageModel(image: "8", imageName: "图片08"),
    imageModel(image: "9", imageName: "图片09")
]
