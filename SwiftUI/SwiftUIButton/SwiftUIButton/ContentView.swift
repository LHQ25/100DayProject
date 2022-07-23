//
//  ContentView.swift
//  SwiftUIButton
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack(spacing: 10) {
            
            Button {
                // 操作
                print("登录成功")
            } label: {
                // 按钮样式
                Text("微信登录")
                    .font(.system(size: 14))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 88 / 255, green: 224 / 255, blue: 133 / 255))
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }

            Button {
                // 操作
                print("登录成功")
            } label: {
                // 按钮样式
                Text("Apple登录")
                    .font(.system(size: 14))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }
            
            HStack {
                ImageButton(img: "1")
                ImageButton(img: "2")
                ImageButton(img: "3")
            }
            
            HStack {
                TextImageButton(img: "1")
                TextImageButton(img: "2")
                TextImageButton(img: "3")
            }
            .padding(.horizontal)
        }
    }
    
    
    
    func TextImageButton(img: String) -> some View {
        Button {
            // 操作
            print("登录成功")
        } label: {
            
            HStack {
                // 按钮样式
               
                Image(img)
                    .resizable()
                    .frame(minWidth: 0, maxWidth: 16, minHeight: 0, maxHeight: 16)
                    .padding()
                    .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
                    .clipShape(Circle())
                
                Text("登录")
                    .font(.system(size: 14))
                    .padding(.leading, 4)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }
        }
        .background(Color(red: 88 / 255, green: 224 / 255, blue: 133 / 255))
        .cornerRadius(8)
        
    }
        
    func ImageButton(img: String) -> some View {
        Button {
            // 操作
            print("登录成功")
        } label: {
            // 按钮样式
            Image(img)
                .resizable()
                .frame(minWidth: 0, maxWidth: 32, minHeight: 0, maxHeight: 32)
                .padding()
                .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
                .clipShape(Circle())
        }
    }
}
