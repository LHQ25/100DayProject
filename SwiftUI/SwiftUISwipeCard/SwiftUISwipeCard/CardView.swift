//
//  CardView.swift
//  SwiftUISwipeCard
//
//  Created by 9527 on 2022/7/15.
//

import SwiftUI

struct CardView: View {
    
    var image: String
    var name: String
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
         
            Image(image)
                .resizable()
                .frame(minWidth: 0, maxWidth: .infinity)
                .scaledToFit()
                .cornerRadius(15)
                .padding(.horizontal, 15)
                
            Text(name)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(3)
                .padding([.bottom], 20)
        }
    }
}
