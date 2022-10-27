//
//  ContentView.swift
//  Grid
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                Text("Hello")
                Image(systemName: "globe")
            }
            
            Divider()
//                .gridCellUnsizedAxes(.horizontal)
//                .gridCellColumns(2)
            
            GridRow(alignment: .center) {
                Image(systemName: "hand.wave")
                Text("World")
            }
            
        }
        // MARK: - Configuring columns
        .gridColumnAlignment(.leading)   // 每列的对齐方式
        // MARK: - Configuring cells
//        .gridColumnAlignment(.trailing)  //Grid的 水平对齐方式
        //.gridCellAnchor(.leading)  // Grid cell的视图指定自定义对齐锚
        //.gridCellUnsizedAxes(.horizontal)  // 要求 Grid 不在指定的轴上为视图提供额外的大小
    }
}
