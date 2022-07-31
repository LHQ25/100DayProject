//
//  ContentView.swift
//  ColourAtla
//
//  Created by 9527 on 2022/7/6.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSearchBar = false
    @State var search: String = ""
    @State var cardItems: [CardModel] = []
    
    // 加载数据
    func loadData() {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url), let jsons = try? JSONDecoder().decode([CardModel].self, from: data) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.cardItems = jsons
                }
            }
        }
    }
    
    func searchColor() {
        
        let query = search.lowercased()
        DispatchQueue.global(qos: .background)
            .async {
                
                let filter = cardItems.filter({ $0.cardColorRBG.lowercased().contains(query) })
                DispatchQueue.main.async {
                    self.cardItems = filter
                }
            }
        
    }
    
    var body: some View {
        VStack {
            
            SwitchSearchView
            
            if cardItems.isEmpty {
                // 未加载数据之前的加载效果
                Spacer()
                LoadingView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                Spacer()
            }else {
                CardListView(cardItems: $cardItems)
            }
        }.onAppear {
            loadData()
        }
    }
    
    private var CardTitleView: some View {
        Text("世界最高级的颜色")
            .font(.system(size: 17))
            .fontWeight(.bold)
    }
    
    private var SearchButtonView: some View {
        Button {
            withAnimation(.easeInOut) {
                showSearchBar.toggle()
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
        }
    }
    
    private var CloseButtonView: some View {
        Button {
            withAnimation(.easeInOut) {
                search = ""
                loadData()
                showSearchBar.toggle()
            }
        } label: {
            Text("取消")
                .foregroundColor(.gray)
        }
    }
    
    private var SwitchSearchView: some View {
        HStack(spacing: 10) {
            
            if showSearchBar {
                // 搜索栏
                SearchBarView(search: $search) {
                    if search != "" {
                        searchColor()
                    }else{
                        search = ""
                        loadData()
                    }
                }
                CloseButtonView
            } else {
                CardTitleView
                Spacer()
                SearchButtonView
            }
        }
        .padding()
        .padding(.bottom, 10)
        .padding(.horizontal)
        .zIndex(1)
    }
    
}

