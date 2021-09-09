//
//  ContentView.swift
//  Day13_8 SwiftUI(HStack & VStack)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack{
            
            VStack(alignment: .leading, spacing: 10){
                HStack(alignment: .center, spacing: 4){
                    Text("h_Text_1")
                    Text("h_Text_2")
                    Text("h_Text_3")
                    
                    
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                HStack(alignment: .bottom, spacing: 10){
                    
                    Text("h_Text_4")
                    Text("h_Text_5")
                    Text("h_Text_6")
                        
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
            VStack(alignment: .trailing, spacing: 10){
                HStack(alignment: .center, spacing: 4){
                    Text("h_Text_2_1")
                    Text("h_Text_2_2")
                    Text("h_Text_2_3")
                    
                    
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                HStack(alignment: .bottom, spacing: 10){
                    
                    Text("h_Text_2_4")
                    Text("h_Text_2_5")
                    Text("h_Text_2_6")
                        
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
            
            ZStack(alignment: .topLeading){
                HStack(alignment: .center, spacing: 4){
                    Text("h_Text_2_1")
                    Text("h_Text_2_2")
                    Text("h_Text_2_3")
                    
                    
                }.frame(width: UIScreen.main.bounds.size.width, height: 50)
                
                HStack(alignment: .bottom, spacing: 10){
                    
                    Text("h_Text_2_4")
                    Text("h_Text_2_5")
                    Text("h_Text_2_6")
                        
                    }.frame(width: UIScreen.main.bounds.size.width, height: 50)
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
