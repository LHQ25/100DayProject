//
//  TopBarMenu.swift
//  SwiftUISwipeCard
//
//  Created by 9527 on 2022/7/15.
//

import SwiftUI

/* 顶部导航栏 */
struct TopBarMenu: View {
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "ellipsis.circle")
                .font(.system(size: 30))
            
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 30))
        }
        .padding()
    }
}
