//
//  ContentView.swift
//  SwiftUIStacks
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("会员套餐")
                        .fontWeight(.bold)
                        .font(.system(.title))
                    Text("解锁高级功能")
                        .fontWeight(.bold)
                        .font(.system(.title))
                }
                Spacer()
            }.padding(.horizontal)
            
            HStack {
                ZStack(alignment: .top) {
                    itemView(title: "连续包月", p: "$18",
                             tc: Color(red: 190 / 255, green: 188 / 255, blue: 184 / 255),
                             sc: Color(red: 239 / 255, green: 129 / 255, blue: 112 / 255),
                             bg: Color(red: 250/255, green: 247/255, blue: 243/255))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(red: 202/255, green: 169/255, blue: 106/255), lineWidth: 2))
                    
                    // 首月特惠
                    Text("首月特惠")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color(red: 202 / 255, green: 169 / 255, blue: 106 / 255))
                        .cornerRadius(4)
                        .offset(x: 0, y: -15)
                }
                
                itemView(title: "1个月", p: "$30",
                         tc: Color(red: 190 / 255, green: 188 / 255, blue: 184 / 255),
                         sc: Color(red: 239 / 255, green: 129 / 255, blue: 112 / 255),
                         bg: Color(red: 244 / 255, green: 244 / 255, blue: 245 / 255))
                .cornerRadius(10)
                
                itemView(title: "12个月", p: "$228",
                         tc: Color(red: 190 / 255, green: 188 / 255, blue: 184 / 255),
                         sc: Color(red: 239 / 255, green: 129 / 255, blue: 112 / 255),
                         bg: Color(red: 244 / 255, green: 244 / 255, blue: 245 / 255))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 6).stroke(Color(red: 202/255, green: 169/255, blue: 106/255), lineWidth: 2)
                    .padding()
                Text("圆角矩形 \n 代替裁剪圆角和边框一起的问题")
                    .fontWeight(.bold)
                    .font(.system(.title))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    func itemView(title: String, p: String, tc: Color, sc: Color, bg: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 17))
                .foregroundColor(tc)
            Text(p)
                .fontWeight(.bold)
                .font(.system(size: 25))
                .foregroundColor(sc)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 90)
        .padding(20)
        .background(bg)
        // 设置圆角和边框有问题
        //            .cornerRadius(10)
        //            .border(Color(red: 202/255, green: 169/255, blue: 106/255), width: 2)
//        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(red: 202/255, green: 169/255, blue: 106/255), lineWidth: 2))
    }
}

