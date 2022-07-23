//
//  ContentView.swift
//  SwiftUILazyGrid
//
//  Created by 9527 on 2022/7/12.
//

import SwiftUI

struct ContentView: View {
    
    private var appleSymbols = ["house.circle", "person.circle", "bag.circle", "location.circle", "bookmark.circle", "gift.circle", "globe.asia.australia.fill", "lock.circle", "pencil.circle", "link.circle"]


    //MARK: - LazyVGrid
    //1. 定义3列; 使用网格布局时，我们要定义的网格是多少列，然后再按照实际的数量，系统可以自动排布多少行
//    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    //2. spacing网格间距: 完全去掉间距，我们只能在从gridItemLayout网格布局调整
//    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    //3. flexible灵活适应修饰符, 自动修改 每项 item 的宽度
//    private var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)

    //4. adaptive自适应修饰符, LazyVGrid垂直网格会在每个GridItem列项大小为80的基础上，在一行中会填充尽可能多的图像
//    private var gridItemLayout = [GridItem(.adaptive(minimum: 80))]

    //5. fixed适应修饰符: 修改单个GridItem列项的宽度，我们可以使用.fixed适应修饰符
//    private var gridItemLayout = [GridItem(.fixed(100)), GridItem(.fixed(150)),GridItem(.fixed(100))]

    //6. 还可以根据业务的不同混合使用
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.fixed(150)),GridItem(.adaptive(minimum: 80))]


    @State var isShowLazyVGrid = false
    

    var body: some View {
        
        if isShowLazyVGrid {
            // 使用LazyVGrid垂直网格和ScrollView滚动视图来实现网格布局
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridItemLayout) {
                    
                    ForEach(0...99, id: \.self) {
                        
                        Image(systemName: appleSymbols[$0 % appleSymbols.count])
                            .font(.system(size: 30))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 80)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                }
            }
        }else {
            
            /*
             ScrollView滚动视图是默认垂直滚动的，如果我们需要使用LazyHGrid水平网格，那么需要同时设置ScrollView滚动视图滚动方向为水平。
             LazyVGrid垂直网格是使用columns列读取数据，而LazyHGrid水平网格是使用rows行读取数据
             */
            ScrollView (.horizontal) {
                LazyHGrid(rows: gridItemLayout,spacing: 10) {
                    
                    ForEach(0 ... 90, id: \.self) {
                        Image(systemName: appleSymbols[$0 % appleSymbols.count])
                            .font(.system(size: 30))
                            .frame(minWidth: 80,minHeight: 80,maxHeight: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
