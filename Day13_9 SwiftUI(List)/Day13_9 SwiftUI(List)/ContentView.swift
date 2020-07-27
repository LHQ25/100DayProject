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
    
    var body: some View {
        //1
//        List {
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//            Text("List")
//        }
        //6
//        List(datas){
//            StreetRow(street: $0)
//        }
        //7
//        List(0..<datas.count){
//            StreetRow(street: self.datas[$0])
//        }
        //8
        List(0..<datas.count, selection: $datas){
            StreetRow(street: self.datas[$0])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
