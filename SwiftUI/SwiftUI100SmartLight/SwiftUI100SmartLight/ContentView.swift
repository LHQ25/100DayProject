//
//  ContentView.swift
//  SwiftUI100SmartLight
//
//  Created by 9527 on 2022/8/1.
//

import SwiftUI

struct ContentView: View {
    
    @State var isOpen: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top){
            bgCard()
            VStack {
                
                titleView()
                
                Spacer()
                
                lightView()
                    
                Spacer()
                
                switchBtn()
            }
        }
    }
    
    func bgCard() -> some View {
        
        Rectangle()
            .foregroundColor(Color(red: 88 / 255, green: 132 / 255, blue: 234 / 255))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .cornerRadius(16)
            .shadow(radius: 2)
            .padding()
    }
    
    func titleView() -> some View {
        Text("卧室灯")
            .font(.system(size: 17))
            .fontWeight(.bold)
            .padding(.top, 40)
            .foregroundColor(.white)
    }
    
    func lightView() -> some View {
        
        Circle()
            .stroke(Color(.systemGray6), lineWidth: 80)
            .opacity(isOpen ? 0.9 : 0.5)
            .frame(width: 20, height: 20, alignment: .center)
            .shadow(color: .white, radius: isOpen ? 30 : 0, x: 0, y: 0)
    }
    
    func switchBtn() -> some View {
        
        VStack(spacing: 20) {
            
            Image(systemName: "power")
                .foregroundColor(isOpen ? .white : .black)
                .font(.system(size: 32))
                .onTapGesture {
                    isOpen.toggle()
                }
            Text(isOpen ? "点击关灯" : "点击开灯")
                .font(.system(size: 17))
                .fontWeight(.bold)
                .foregroundColor(isOpen ? .white : .black)
        }
        .padding(.bottom, 80)
    }
}
