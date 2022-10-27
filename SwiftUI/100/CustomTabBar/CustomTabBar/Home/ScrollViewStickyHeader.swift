//
//  ScrollViewStickyHeader.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/8.
//

import SwiftUI

struct StickyHeader<Content: View>: View {
    
    var minHeight: CGFloat
    var content: Content
    
    init(minHeight: CGFloat = 200, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: .global).minY <= 0 {
                content
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }else{
                content
                    .offset(y: -geo.frame(in: .global).minY)
                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
            }
        }.frame(minHeight: minHeight)
    }
}

struct ScrollViewStickyHeader: View {
    var body: some View {
        
//        ScrollView(.vertical, showsIndicators: false) {
//            StickyHeader {
//                ZStack {
//                    Color(red: 35/255, green: 45/255, blue: 50/255)
//                    VStack {
//                        Text("Joshua Tree")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                        Text("California")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//            // Scroll View Content Here
//            // ...
//            Color.red
//        }
        
        ScrollView(.vertical, showsIndicators: false) {
            StickyHeader {
                StickyHeader {
                    Image("11")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            
            // Scroll View Content Here
            // ...
            Color.red
                .frame(height: 400)
        }
    }
}

struct ScrollViewStickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewStickyHeader()
    }
}
