//
//  ContentView.swift
//  SwiftUIGremetryReader
//
//  Created by 9527 on 2022/7/29.
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        // ExampleView()

        // ExampleView2()

        ExampleView3()

        /*
            当你开始使用GeometryReader， 你就会发现所谓的鸡和鸡蛋的问题。
            因为GeometryReader需要给子级试图提供可用空间，它首先需要尽可能多的占用空间。
            但是子类可能会设置一个小的空间，这时候GeometryReader还是尽可能的保持大。
            一旦子级试图确定了其所需空间， 你可能会被迫缩小GeometryReader。这时候子级试图就会GeometryReader计算出的新的大小做出反应。 一个循环就产生了。
            所以 当遇到是子级试图依赖父级试图的大小，还是父级试图依赖于子级试图的大小。 可能GeometryReader并不适合解决你的布局问题
         */
    }
}

struct ExampleView: View {

    var body: some View {

        VStack {
            Text("Hello There")

            Rectangle()
                    .fill(Color.blue)
        }.frame(width: 150, height: 100)
                .border(Color.black)
    }
}

struct ExampleView2: View {
    var body: some View {

        VStack {
            Text("Hello There")

            //MARK: -  GeometryReader: 一个容器视图，根据其自身大小和坐标空间定义其内容
            GeometryReader { proxy in
                // proxy.size: 父级视图建议的大小
                // proxy.frame(in: .local): frame方法暴露给我们了父级视图建议区域的大小位置，可以通过 .local,.global,.named() 来获取不同的坐标空间。 .named() 用来获取一个被命名的坐标空间。我们可以通过这个命名来获取其他view坐标空间
                // proxy.safeAreaInsets:
                Rectangle()
                        .path(in: CGRect(x: proxy.size.width + 5, y: 0, width: proxy.size.width / 2.0, height: proxy.size.height / 2.0))
                        .fill(Color.blue)
            }
        }.frame(width: 150, height: 100)
                .border(Color.black)
    }
}

struct ExampleView3: View {
    var body: some View {

        HStack {
            Text("SwiftUI")
                    .foregroundColor(.black).font(.title).padding(15)
//                    .background(RounderCorners(color: .green, tr: 30, bl: 30))
                    .overlay(RounderCorners(color: .green, tr: 30, bl: 30)).opacity(0.5)

            Text("Lab")
                    .foregroundColor(.black).font(.title).padding(15)
//                    .background(RounderCorners(color: .green, tl: 30, br: 30))
                    .overlay(RounderCorners(color: .green, tl: 30, br: 30)).opacity(0.5)

        }.padding(20).border(Color.gray).shadow(radius: 3)
    }
}

struct RounderCorners: View {

    var color: Color = .black
    var tl: CGFloat = 0
    var tr: CGFloat = 0
    var bl: CGFloat = 0
    var br: CGFloat = 0

    var body: some  View {
        GeometryReader{ proxy in

            Path{ path in
                let w = proxy.size.width
                let h = proxy.size.height

                let tr = min(min(tr, h/2), w/2)
                let tl = min(min(tl, h/2), w/2)
                let bl = min(min(bl, h/2), w/2)
                let br = min(min(br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }.fill(color)
        }
    }
}
