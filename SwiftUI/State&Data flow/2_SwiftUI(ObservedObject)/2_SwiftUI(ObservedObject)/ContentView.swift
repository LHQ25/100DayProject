//
//  ContentView.swift
//  2_SwiftUI(ObservedObject)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI


struct ContentView: View {

    /* 订阅可观察对象并在可观察对象更改时使视图无效的属性包装器类型 */
    @ObservedObject
    private var model: Test = Test()
    
//    @ObservedObject(initialValue: Test())
//    private var model: Test
    
//    @ObservedObject(wrappedValue: Test())
//    private var model: Test
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            
           
            
        }
    }
    
    func test() {
    }
}

class Test: ObservableObject {
    
    
}

