//
//  SidebarMenu.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct SidebarStack<SidebarContent: View, Content: View>: View {
    
    let sidebarContent: SidebarContent
    let mainContent: Content
    let sidebarWidth: CGFloat
    
    @Binding var showSidebar: Bool
    
    init(sidebarWidth: CGFloat, showSidebar: Binding<Bool>, @ViewBuilder sidebar: ()->SidebarContent, content: ()->Content) {
        self.sidebarWidth = sidebarWidth
        self._showSidebar = showSidebar
        sidebarContent = sidebar()
        mainContent = content()
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            sidebarContent
                .frame(width: sidebarWidth, alignment: .center)
                .edgesIgnoringSafeArea(.all)
                .offset(x: showSidebar ? 0 : -1 * sidebarWidth, y: 0)
                .animation(.easeIn.speed(2))
            
            mainContent
                .overlay(
                    Group {
                        if showSidebar {
                            Color.white
                                .opacity(showSidebar ? 0.01 : 0)
                                .onTapGesture {
                                    showSidebar = false
                                }
                        }else{
                            Color.clear
                                .opacity(showSidebar ? 0 : 0)
                                .onTapGesture {
                                    showSidebar = false
                                }
                        }
                    }
                )
                .offset(x: showSidebar ? sidebarWidth : 0, y: 0)
                .animation(.easeInOut.speed(2))
        }
        
    }
}

