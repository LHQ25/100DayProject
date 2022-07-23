//
//  DetailView.swift
//  SwiftUINavigationView
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

//详情页面
struct DetailView: View {
    
    var message: Message
    
    @Environment(\.presentationMode) var mode

    
    var body: some View {
        
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 80, height: 80)
            Text(message.name)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)                        // 导航栏自定义返回 隐藏系统返回按钮
//        .navigationBarItems(leading: Button {                     // 即将废弃的方法
//            self.mode.wrappedValue.dismiss()
//        } label: {
//            //按钮及其样式
//                Image(systemName: "chevron.left")
//                .foregroundColor(.gray)
//        })
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {    // 新写法
                Button {
                    self.mode.wrappedValue.dismiss()                // SwiftUI提供了(.presentationMode)内置环境值，我们可以用这个环境值实现返回到前一个视图的操作
                } label: {
                    //按钮及其样式
                        Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

//MARK: - Transition转场动画
extension AnyTransition {
    
    static var trailingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .trailing).combined(with: .move(edge: .bottom)))
    }
    
    static var leadingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity, removal: .scale(scale: 1.5).combined(with: .move(edge: .leading).combined(with: .move(edge: .bottom)) ))
    }
}
