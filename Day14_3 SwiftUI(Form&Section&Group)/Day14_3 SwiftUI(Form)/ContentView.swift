//
//  ContentView.swift
//  Day14_3 SwiftUI(Form)
//
//  Created by 亿存 on 2020/7/28.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //用于对用于数据输入的控件,进行分组的容器。
        Form {
            Section(header: Text("Section-header")) {
                Text("头部")
            }
            Section() {
                
                Text("Section")
            }
            Group {
                Text("输入框")
            }
            Group {
                Text("输入框")
            }
            
            Section(footer: Text("Section-footer")) {
                Text("尾部")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
