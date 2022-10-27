//
//  ContentView.swift
//  2_SwiftUI(Link)
//
//  Created by 9527 on 2022/9/23.
//

import SwiftUI

/* 用于导航到 URL 的控件 */
struct ContentView: View {
    
    var body: some View {
        VStack {
            
            // MARK: - Creating a link
            Link("百度", destination: URL(string: "https://www.baidu.com")!)
            //MARK: - Styling the link text
                .font(Font.title)
                .foregroundColor(.yellow)
            Divider()
            Link(destination: URL(string: "https://www.baidu.com")!) {
                Text("百度")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

