//
//  RootView.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct RootView: View {
    
    @State
    var selection: Int = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            HomeTab()
                .tag(0)
            FavoritesTab()
                .tag(1)
            SettingsTab()
                .tag(2)
        }
        .overlay(
            Color.white
                .edgesIgnoringSafeArea(.vertical)
                .frame(height: 50)
                .shadow( color: Color(white: 0, opacity: 0.1), radius: 9, y: -2)
                .overlay(
                    HStack{
                        Spacer()
                        Button {
                            selection = 0
                        } label: {
                            Image(systemName: "house.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 0 ? 1 : 0.4)
                        }
                        Spacer()
                        Button {
                            selection = 1
                        } label: {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 1 ? 1 : 0.4)
                        }
                        Spacer()
                        Button {
                            selection = 2
                        } label: {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 2 ? 1 : 0.4)
                        }
                        Spacer()
                    }
                )
            , alignment: .bottom)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
