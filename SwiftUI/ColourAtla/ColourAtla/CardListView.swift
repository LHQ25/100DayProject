//
//  CardListView.swift
//  ColourAtla
//
//  Created by 9527 on 2022/7/9.
//

import SwiftUI

struct CardListView: View {
    
    @Binding var cardItems: [CardModel]
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            ForEach(cardItems, id: \.cardColorRBG) { item in
                VStack(spacing: 10) {
                    CardViewExamples(cardBGColor: Color.Hex(item.cardBGColor), cardColorName: item.cardColorName, cardColorRBG: item.cardColorRBG)
                }
            }
        }
    }
    
    func CardViewExamples(cardBGColor: Color, cardColorName: String, cardColorRBG: String) -> some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            
            Rectangle()
                .fill(cardBGColor)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 110)
                .cornerRadius(8)
            
            HStack {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(cardColorName)
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(cardColorRBG)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
        }
        .contextMenu {  // 悬浮窗口: ContextMenu上下文菜单
            Button {
                UIPasteboard.general.string = cardColorName  // 把 cardColorName 卡片颜色值的内容复制到 剪切板 中
            } label: {
                Text("复制颜色值")
            }
        }.padding(.horizontal)
    }
}

