//
//  SimpleProductCard.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct CardModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

struct ProductCardShow: View {
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {
            ProductCard(image: "1", title: "Autumn Soup", type: "entry", price: 200.12)
            ProductCard(image: "2", title: "Autumn Soup", type: "entry", price: 200.12)
            ProductCard(image: "3", title: "Autumn Soup", type: "entry", price: 200.12)
        }
        
    }
}

struct ProductCard: View {
    
    var image: String
    var title: String
    var type: String
    var price: Double
    
    var body: some View {
        
        HStack(alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text(type)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                HStack {
                    Text("$"+String(format: "%0.2f", price))
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
                .padding(.trailing, 20)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}

struct SimpleProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ProductCardShow()
    }
}

