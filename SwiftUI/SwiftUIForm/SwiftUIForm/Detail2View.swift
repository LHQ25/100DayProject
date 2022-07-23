//
//  Detail2View.swift
//  SwiftUIForm
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct DetailView: View {
    
    var title: String
    
    var displayState = [ "接收关闭", "仅限联系人", "所有人"]

    @State var selection: String = "接收关闭"
    
    @State var amount: Int = 0
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $selection) {
                    ForEach(displayState, id: \.self) {
                        Text($0)
                    }
                } label: {
                    Text(title)
                }
                
                Stepper("\(amount)") {
                    self.amount += 1
                } onDecrement: {
                    self.amount -= 1
                }

            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
