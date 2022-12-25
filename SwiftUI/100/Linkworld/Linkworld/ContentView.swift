//
//  ContentView.swift
//  Linkworld
//
//  Created by 9527 on 2022/12/6.
//
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ViewModel()
    @State private var showNewView:Bool = false
        
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 246 / 255, green: 247 / 255, blue: 255 / 255)
                    .edgesIgnoringSafeArea(.all)
                
                List() {
                    ForEach(vm.models, id: \.id) { item in
                        // 隐藏跳转指示箭头
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: HomePageView(platformName: item.platformName, url: item.indexURL)) {
                                EmptyView()
                            }
                            .opacity(0)

                            // 提示文字
                            HStack {
                                Spacer()
                                Text("左滑删除")
                                .padding()
                                .foregroundColor(Color(.systemGray))
                            }
                            
                            CardView(platformIcon: item.platformIcon, title: item.title, platformName: item.platformName, indexURL: item.indexURL, viewModel: vm, itemId: item.id)
                                // 长按唤起删除
                                .contextMenu{Button(action: {
                                    vm.deleteItem(itemId: item.id)
                                }, label: {
                                    Text("删除")
                                })}
                                
                        }
                    }
                }
                .background(Color.white)
                .listRowBackground(Color.clear)
                // .listStyle(.plain)
                // .listRowSeparatorTint(Color.red)
                // .listRowSeparator(.hidden)
            }
            .navigationBarTitle("HQ", displayMode: .inline)
            .navigationBarItems(trailing: addBtn())
        }
        .sheet(isPresented: $showNewView) {
            NewView(showNewView: $showNewView, vm: vm)
        }
        .onAppear {
            vm.getData()
        }
        
    }
    func addBtn() -> some View {
        Button(action: {
            showNewView.toggle()
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 17))
                .foregroundColor(.blue)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
