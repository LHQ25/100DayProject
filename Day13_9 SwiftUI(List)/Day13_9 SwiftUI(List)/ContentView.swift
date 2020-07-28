//
//  ContentView.swift
//  Day13_9 SwiftUI(List)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct Street: Identifiable {
    
    var id = UUID()
    
    var name: String
}

struct StreetRow: View {
    
    var street: Street
    
    var body: some View {
        Text("The street name is \(street.name)")
    }
}

struct ContentView: View {
    
    @State var datas = [Street(name: "1"),Street(name: "2"),Street(name: "3"),Street(name: "4")]
    @State var section:Set = [1, 2]
    
    @State var singleSection:Int? = 1
    
    var body: some View {
        
        //1 创建具有给定内容的列表。
//        List {
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//        }
        //2 创建一个列表，该列表基于KeyPath来标识其行。
//        List(datas, id: \Street.id){
//            StreetRow(street: $0)
//        }
        //3. 创建一个列表，该列表基于KeyPath来标识其行，可以选择允许用户选择多个行。
        List(datas, id: \Street.id, selection: $section){
            StreetRow(street: $0)
        }
        //4. 创建一个列表，该列表基于到基础数据标识符的键路径来标识其行，可以选择允许用户选择单个行。
//        List(datas, id: \Street.id, selection: $singleSection){
//            StreetRow(street: $0)
//        }
        //5. 创建一个列表，该列表根据可识别数据的集合计算其行
//        List(datas){
//            StreetRow(street: $0)
//        }
        
        //6 创建一个列表，在恒定范围内按需计算其视图
//        List(0..<datas.count ){
//            StreetRow(street: self.datas[$0])
//        }
        //7 创建一个列表，在恒定范围内按需计算其视图 , 选择多个行
//        List(0..<datas.count, selection: $section){
//            StreetRow(street: self.datas[$0])
//        }
        //8 创建一个列表，该列表根据可识别数据的基础集合按需计算其行，可以选择允许用户选择多个行
//        List(datas, selection: $section){
//            StreetRow(street: $0)
//        }
        //9 恒定范围内按需计算其视图 选择单个行
//        List(0..<datas.count, selection: $singleSection){
//            StreetRow(street: self.datas[$0])
//        }
        
        //10 创建一个列表，该列表根据基础集合计算其行，允许用户选择单个行
//        List(datas, selection: $singleSection) {
//            StreetRow(street: $0)
//        }
        
        //11 创建一个层次结构列表，该层次结构列表根据集合按需计算其行，可以选择允许用户选择多个行  iOS 14
//        init<Data, RowContent>(Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, rowContent: (Data.Element) -> RowContent)
        
        //12 创建一个层次结构列表，该层次结构列表根据集合按需计算其行，可以选择允许用户选择单个行。 iOS 14
//        init<Data, RowContent>(Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, rowContent: (Data.Element) -> RowContent)
        
        //13 创建一个层次结构列表，该层次结构列表根据可识别数据的基础集合按需计算其行。 iOS 14
//        init<Data, RowContent>(Data, children: KeyPath<Data.Element, Data?>, rowContent: (Data.Element) -> RowContent)
        
        //14 创建一个层次结构列表，该层次结构列表根据数据标识符的关键路径来标识其行 iOS 14
        //init<Data, ID, RowContent>(Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, rowContent: (Data.Element) -> RowContent)
        
        //15 创建一个层次结构列表，该层次结构列表根据基础数据标识符的关键路径来标识其行，可以选择允许用户选择单个行。 iOS 14
//        init<Data, ID, RowContent>(Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, rowContent: (Data.Element) -> RowContent)
        
        //16 创建具有给定内容的列表，该列表支持选择单行
//        List(selection: $singleSection) {
//            Text("List")
//            Text("List")
//        }
        
        //17 用给定的内容创建一个列表，该列表支持选择多行
//        List(selection: $section) {
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
