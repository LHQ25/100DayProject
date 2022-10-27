//
//  ContentView.swift
//  3_SwiftUI(Menu)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

/* 用于显示操作菜单的控件 */
struct ContentView: View {
    
    @State var appearance: String = "List"
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            menuView()
            menuView2()
        }
        .border(Color.red, width: 1)
        .padding(20)
        
    }
    
    func menuView() -> some View {
        // MARK: - Creating a menu from content
        Menu {
            
            Button(action: addCurrentTabToReadingList) {
                Label("Add to Reading List", systemImage: "eyeglasses")
            }
            Button(action: bookmarkAll) {
                Label("Add Bookmarks for All Tabs", systemImage: "book")
            }
            Button(action: show) {
                Label("Show All Bookmarks", systemImage: "books.vertical")
            }
            
            Picker("Appearance", selection: $appearance) {
                Label("Icons", systemImage: "square.grid.2x2")
                Label("List", systemImage: "list.bullet")
            }
            
            Menu {
                Button(action: addCurrentTabToReadingList) {
                    Label("Add to Reading List", systemImage: "eyeglasses")
                }
                Button(action: bookmarkAll) {
                    Label("Add Bookmarks for All Tabs", systemImage: "book")
                }
                Button(action: show) {
                    Label("Show All Bookmarks", systemImage: "books.vertical")
                }
            } label: {
                Text("Meun4")
            }
                
        } label: {
            Text("Meun")
        } primaryAction: { // 点击 相应，长按弹窗menu, 不加则直接弹窗menu
            addBookmark()
        }
        .menuOrder(.fixed)   // 菜单显示其内容的顺序。
//        .menuStyle(.automatic)
        .menuStyle(.borderlessButton)
//        .menuStyle(.button)
    }
    
    func menuView2() -> some View {
        Menu("menu2", content: {
            Button(action: show) {
                Label("Show All Bookmarks", systemImage: "books.vertical")
            }
        })
        .menuStyle(RedBorderMenuStyle())
    }
    
    private func addBookmark() {
        debugPrint("addBookmark")
    }
    
    private func addCurrentTabToReadingList() {
        debugPrint("addCurrentTabToReadingList")
    }
    
    private func bookmarkAll() {
        debugPrint("bookmarkAll")
    }
    
    private func show() {
        debugPrint("show")
    }
}

// MARK: - Creating a menu from a configuration
struct RedBorderMenuStyle: MenuStyle {
    
    // MenuStyle: 一种将标准交互行为和自定义外观应用于视图层次结构中的所有菜单的类型。
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .border(Color.red)
    }
}


//struct PickerOption: View {
//
//    var content: ViewBuilder
//
//    var body: some View {
//
//        content
//    }
//}
