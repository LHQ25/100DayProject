//
//  BottomBarMenu.swift
//  SwiftUISwipeCard
//
//  Created by 9527 on 2022/7/15.
//

import SwiftUI

struct BottomBarMenu: View {
    
    var delAction: ()->Void
    
    var heartAction: ()->Void
    
    var body: some View {
        
        HStack {
            Image(systemName: "xmark")
                .font(.system(size: 30))
                .foregroundColor(.black)
                .onTapGesture {
                    delAction()
                }
            
            Button {
                
            } label: {
                Text("立即选择")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 35)
                    .padding(.vertical, 15)
                    .background(Color.black)
                    .cornerRadius(10)
            }.padding(.horizontal, 20)
            
            Image(systemName: "heart")
                .font(.system(size: 30))
                .foregroundColor(.black)
                .onTapGesture {
                    heartAction()
                }
        }
    }
}
