//
//  HomePageView.swift
//  Linkworld
//
//  Created by 9527 on 2022/12/7.
//

import SwiftUI

struct HomePageView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var platformName: String
    var url: String
    
    var body: some View {
        SiteView(indexUrl: url)
            .navigationTitle(platformName)
            .navigationBarTitleDisplayMode(.inline)
            // 自定义返回按钮
            // .navigationBarBackButtonHidden(true)
            // .navigationBarItems(leading: backBtn())
            .backButtonCustom {
                presentationMode.wrappedValue.dismiss()
            }
    }
    
    // 返回按钮
    func backBtn() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 17))
                .foregroundColor(.black)
        }
    }
    
}

extension View {
    func backButtonCustom(_ action: @escaping ()->Void) -> some View {
        navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: action) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
            })
    }
}

