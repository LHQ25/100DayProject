//
//  ContentView.swift
//  Day14_5 SwiftUI(Alert)
//
//  Created by 亿存 on 2020/7/28.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showAlert = true
    @State var showAlert2 = false
    var body: some View {
        
//        Text("Alert").alert(isPresented: $showAlert) {
//            //两个按钮
////            Alert(title: Text("Alert"), message: nil, primaryButton: Alert.Button.default(Text("primaryButton"), action: {
////
////            }), secondaryButton: .cancel())
//
//            // 一个取消按钮
//            Alert(title: Text("Alert"), message: nil, dismissButton: .cancel(Text("取消")))
//
//            //
//
//        }
        
        Button("actionSheet"){
            self.showAlert2 = !self.showAlert2
        }.actionSheet(isPresented: $showAlert2) {
            ActionSheet(title: Text("ActionSheet"), message: nil, buttons: [.default(Text("t1")), .default(Text("t2"), action: {
                
            }),.destructive(Text("destructive"), action: {
                
            }), .cancel()])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
