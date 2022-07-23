//
//  ContentView.swift
//  SwiftUIList02
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

/*
    1、onDelete滑动删除和onMove拖动排序
    2、ContextMenu上下文菜单
    3、ActionSheets弹窗的使用
*/


struct ContentView: View {

    // 定义数组，存放数据
     @State var messages = [Message(name: "这是微信", image: "circle.square"),
                    Message(name: "这是QQ", image: "globe.americas"),
                    Message(name: "这是微博", image: "sun.min"),
                    Message(name: "这是手机", image: "keyboard"),
                    Message(name: "这是邮箱", image: "timelapse")]

    @State var isShowSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(messages){ iten in
                    HStack {
                        Image(systemName: iten.image)
                                .resizable()
                                .foregroundColor(Color.cyan)
                                .frame(width: 40, height: 40)
                                .cornerRadius(5)
                        Text(iten.name)
                                .padding()
                    }.contextMenu {                             // ContextMenu上下文菜单
                        Button(action: {
                            deleteRow(with: iten.id)
                        }, label: {
                            HStack {
                                Text("删除")
                                Image(systemName: "trash")
                            }  })
                    }.actionSheet(isPresented: $isShowSheet) {
                        
                        ActionSheet(title: Text("确定删除？"), message: nil, buttons: [
                            .destructive(Text("删除"), action: {
                                deleteRow(with: iten.id)
                            }),
                            .cancel()])
                    }
                }
                .onDelete(perform: deleteRow(with: ))           // onDelete滑动删除
                .onMove(perform: removeRow(with:offset:))       // onMove拖动排序, perform中引用的是排序的方法，我们定义一个移动方法为moveItem
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            // .navigationBarItems(trailing: EditButton())         // 给List列表创建导航栏，还可以使用SwiftUI已经封装好的EditButton编辑按钮，从而实现列表快速进入编辑状态
        }

    }

    func removeRow(with indexSet: IndexSet, offset: Int) {
        messages.move(fromOffsets: indexSet, toOffset: offset)
    }

    func deleteRow(with id: UUID) {
        messages.removeAll(where: { $0.id == id })
    }

    func deleteRow(with set: IndexSet) {
        messages.remove(atOffsets: set)
    }
}



struct Message: Identifiable {
    var id = UUID()
    var name: String
    var image: String
}
