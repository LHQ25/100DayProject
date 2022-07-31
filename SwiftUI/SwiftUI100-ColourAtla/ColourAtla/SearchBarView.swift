//
//  SearchBarView.swift
//  ColourAtla
//
//  Created by 9527 on 2022/7/9.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var search: String

    var searchChange: (()->Void)?
    
    var body: some View {
        TextField("搜索颜色值", text: $search)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(6)
            .overlay(
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
            )
            .padding(.horizontal, 10)
            .onChange(of: search) { newValue in
                searchChange?()
            }
    }
}
