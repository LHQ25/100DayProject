//
//  ContentView.swift
//  Day12_3 SwiftUI_Image
//
//  Created by 亿存 on 2020/7/22.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            ///创建
//            VStack{
//                Image("123", bundle: Bundle.main)
//                    .position(CGPoint(x: 0, y: 0))
//                    .frame(width: 40, height: 40)
                
                ///指定的标签创建可以用作控件内容的标签图像
//                Image("123", bundle: Bundle.main, label: Text("Text"))
//                .frame(width: 40, height: 40)
                
                ///未标记的装饰性图像。
//                Image(decorative: "123", bundle: Bundle.main)
                
//                Image(decorative: UIImage(named: "123")!.cgImage!, scale: 0.5, orientation: .left)
                
//                Image(uiImage: UIImage(named: "123")!)
                
//                Image(UIImage(named: "123")!.cgImage!, scale: 0.5, label: Text("标签2"))
                
//                Image(systemName: "address")
//            }
            //样式
            VStack{
                //
//                Image("123", bundle: Bundle.main).renderingMode(.original)
                 
                Image("123", bundle: Bundle.main)
                    .renderingMode(.original)
                    .antialiased(true) //抗锯齿
                    .resizable(capInsets: EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0), resizingMode: .stretch) //截取
                    .frame(width: 40, height: 40)
                
                ///图片质量
//                Image("123", bundle: Bundle.main)
//                    .interpolation(.high)
//                    .frame(width: 40, height: 40)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
