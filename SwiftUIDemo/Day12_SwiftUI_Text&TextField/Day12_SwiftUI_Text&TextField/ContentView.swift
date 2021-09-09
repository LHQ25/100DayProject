//
//  ContentView.swift
//  Day12_SwiftUI_Text&TextField
//
//  Created by 亿存 on 2020/7/22.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let font = Font.system(.headline, design: .rounded)
    
    let c = String("创建3")
    
    var body: some View {
        
        VStack{
            
            VStack{
                //Create
                
                Text(LocalizedStringKey("创建1"), tableName: nil, bundle: nil, comment: "comment")
                Text("创建2")
                Text(verbatim: c)
                
                Divider()
            }
            ///Creating a Text View for a Date   iOS 14.0 +  无法演示
//            VStack{
//
//            }
            
            ///Choosing a Font
            VStack{
                
                Text("Font")
                    .font(font)
                Text("fontWeight").fontWeight(.bold)
                Divider()
            }
            
            ///文字样式
            VStack(alignment: .center, spacing: 3, content: {
                
                Text("字体颜色")
                    .foregroundColor(.green)
                Text("粗体").bold()
                Text("斜体").italic()
                Text("文本 中线").strikethrough(true, color: .red)
                Text("文本underline").underline(true, color: .green)
                Text("字符之间的间距或字距").kerning(8)
                Text("文本追踪").tracking(8)
                Text("文本相对于基线的垂直偏移量").baselineOffset(-3)
                
            })
            ///文本适合可用空间
            VStack{
                
                Text("设置此视图中的文本是否在必要时可以压缩字符之间的空格以使文本适合一行")
                    .allowsHitTesting(true)
                Text("设置此视图中文本缩小到适合可用空间的最小数量")
                    .frame(width: 100, height: 30, alignment: .trailing)
                    .minimumScaleFactor(0.3)
                Text("设置此视图中文本缩小到适合可用空间的最小数量")
                    .frame(width: 100, height: 30, alignment: .center)
                    .truncationMode(.middle)
            }
            ///处理多行文字
            VStack{
                Text("文本在此视图中可占用的最大行数")
                    .lineLimit(1)
                Text("文本行之间的间距\n文本行之间的间距")
                    .lineSpacing(8)
                Text("多行文字的对齐方式\n多行文字的对齐方式\n多行文字的对齐方式").frame(width: 300)
                    .multilineTextAlignment(.trailing)
            }
            ///布局方向  和  操作符
            VStack{
                Text("布局方向从右到左时，此视图是否水平翻转其内容")
                    .flipsForRightToLeftLayoutDirection(true)
                
                /**
                 +
                 ==
                 !=
                 */
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
