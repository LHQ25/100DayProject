//
//  DetailView.swift
//  SwiftUIModalView
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

// 详情页
struct DetailView: View {
    
     @Environment(\.presentationMode) var presentationMode
    
    // 返回 方法1
    @Binding var showDetailView: Bool
    
    @State var isShowAlert: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                Text("这是一个新页面")
                    .navigationBarItems(leading: Button(action: {
                        // 返回 方法1
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .foregroundColor(.gray)
                    }))
            }
            
            Button {
                self.isShowAlert.toggle()
            } label: {
                Text("Alert")
            }
            .alert("alert", isPresented: $showDetailView) {
                HStack {
                    Button(role: .none, action: {self.isShowAlert.toggle() } , label: { Text("OK") })
                    Button(role: .cancel, action: {self.isShowAlert.toggle() } , label: { Text("Cancel") })
                }
            } message: {
                Text("message")
            }

            
            NavigationView {
                Text("这是一个新页面2")
                    .navigationBarItems(trailing: Button(action: {
                        // 返回 方法2
                        self.showDetailView.toggle()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .foregroundColor(.gray)
                    }))
            }
        }

    }
}
