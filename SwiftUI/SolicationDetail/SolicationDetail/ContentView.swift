//
//  ContentView.swift
//  SolicationDetail
//
//  Created by 娄汉清 on 2022/1/11.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    var body: some View {
        List{
            HeaderView()
                .cornerRadius(0)
                .frame(height: 251.0)
                .background(Image("banner")
                                .aspectRatio(contentMode: .fill)
                                .blur(radius: 1, opaque: true))
            
            
        }
    }
}

struct HeaderView: View {
    
    var body: some View {
        
//        ZStack(alignment: .top) {
            
            HStack(alignment: .center, spacing: 15) {
                
                Image("banner")
                    .frame(width: 110.0, height: 130.0)
                    .cornerRadius(/*@START_MENU_TOKEN@*/4.0/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Text("二十世纪艺术晚间拍卖 艺术家布面油画印象派罗伊希里斯特")
                }
                
                padding(0)
            }
            
        background(Color.yellow)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

