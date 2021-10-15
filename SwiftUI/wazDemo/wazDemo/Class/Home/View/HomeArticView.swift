//
//  HomeArticView.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/16.
//

import SwiftUI

struct HomeArticView: View {
    
    var title: String = ""
    var time: String = ""
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 8) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .lineLimit(2)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Text(time)
                    
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.top, 4.0)
            }
            
            Spacer()
            
            Image("go_detail")
                .renderingMode(.original)
                .frame(width: 20.0, height: 20.0)
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
    }
}
