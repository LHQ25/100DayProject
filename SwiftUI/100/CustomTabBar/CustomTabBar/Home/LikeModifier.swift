//
//  LikeModifier.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/13.
//

import SwiftUI

struct LikeModifier: ViewModifier {
    
    @State var liked: Bool = false
    var callback: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Image(systemName: "heart.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .padding(10.5)
                    .background(.red)
                    .cornerRadius(18)
                    .offset(x: 18, y: -18)
                    .opacity(liked ? 1 : 0)
                    .scaleEffect(liked ? 1 : 0, anchor: .center)
                    .animation(.easeInOut(duration: 0.2))
                , alignment: .topTrailing
            )
            .gesture(
                TapGesture(count: 2)
                    .onEnded({
                        withAnimation {
                            liked.toggle()
                        }
                        callback()
                    })
            )
    }
}

extension View {
    
    func onFavorite(callback: @escaping () -> Void) -> some View {
        modifier(LikeModifier(callback: callback))
    }
    
}

struct LikeModifierView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onFavorite {
                
            }
//            .modifier(LikeModifier{
//                debugPrint("双击")
//            })
    }
}

struct LikeModifier_Previews: PreviewProvider {
    static var previews: some View {
        LikeModifierView()
    }
}
