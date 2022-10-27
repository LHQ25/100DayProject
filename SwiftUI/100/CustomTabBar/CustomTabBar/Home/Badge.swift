//
//  Badge.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct BadgeShow: View {
    
    @State
    var filters: [String] = ["SwiftUI", "Programming", "iOS", "Mobile Development", "😎"]
    
    var body: some View {
     
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters, id: \.self) { filter in
                    Badge(name: filter, color: Color(red: 228/255, green: 237/255, blue: 254/255), type: .removable({
                        withAnimation{
                            filters.removeAll { $0 == filter }
                        }
                    }))
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
}


struct Badge: View {
    
    var name: String
    var color: Color = .blue
    var type: BadgeType = .normal
    
    enum BadgeType {
        case normal
        case removable(()->Void)
    }
    
    var body: some View {
        HStack {
            Text(name)
                .font(Font.caption.bold())
                
            switch type {
            case .removable(let _callback):
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8, alignment: .center)
                    .font(Font.caption.bold())
                    .onTapGesture {
                        _callback()
                    }
            default:
                EmptyView()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color)
        .cornerRadius(20)
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        BadgeShow()
    }
}
