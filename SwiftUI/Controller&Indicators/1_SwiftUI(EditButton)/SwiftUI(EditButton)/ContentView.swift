//
//  ContentView.swift
//  SwiftUI(EditButton)
//
//  Created by 9527 on 2022/9/23.
//

import SwiftUI

/* 切换 `编辑模式` 环境值 的 按钮 */
struct ContentView: View {
    
    @State private var fruits = [
        "Apple",
        "Banana",
        "Papaya",
        "Mango",
        "custom"
    ]
    
    @Environment(\.editMode)
    private var editMode
    
    @State
    private var name = "Maria Ruiz"
    
    var body: some View {
        
        NavigationView {
            
//            List {
//                // ForEach 定义了 onDelete(perform:) 和 onMove(perform:) 的行为，所以当用户点击 Edit 时，可编辑列表会显示删除和移动 UI。
//                // 请注意，当编辑模式处于活动状态时，编辑按钮会显示标题“done”
//                ForEach(fruits, id: \.self) {
//                    Text($0)
//                }
//                .onDelete { index in
//                    fruits.remove(atOffsets: index)
//                }
//                .onMove {
//                    fruits.move(fromOffsets: $0, toOffset: $1)
//                }
//            }
//            .navigationTitle("Friuts")
//            .toolbar {
//                // EditButton 为支持编辑模式的容器中的内容切换环境的 editMode 值
//                EditButton()
//
//            }
            
            // 还可以创建对 编辑模式 状态的更改做出反应的自定义视图
            Form(content: {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Name", text: $name)
                }else{
                    Text(name)
                }
            })
            .animation(nil, value: editMode?.wrappedValue)
            .navigationTitle("Friuts")
            .toolbar {
                EditButton()
            }
        }
    }
    
    
}
