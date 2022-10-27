//
//  HomeTab.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct HomeTab: View {
    var body: some View {
        
        NavigationView {
            
            List {
                Section {
                    NavigationLink {
                        BadgeShow()
                    } label: {
                        Text("Badge List")
                    }
                    NavigationLink {
                        ProductCardShow()
                    } label: {
                        Text("Custom Modifier, 简单卡片效果")
                    }
                    
                    NavigationLink {
                        AsyncButtonShow()
                    } label: {
                        Text("异步按钮")
                    }
                    
                    NavigationLink {
                        WaveView()
                    } label: {
                        Text("水波动画, Shap")
                    }
                    
                    NavigationLink {
                        WaveView2()
                    } label: {
                        Text("水波动画2, AnyTransition")
                    }
                    
                    NavigationLink {
                        AlignmentControl(tintColor: .red, baseColor: .gray)
                    } label: {
                        Text("Alignment Control")
                    }
                    
                    NavigationLink {
                        ToggleStylesView()
                    } label: {
                        Text("ToggleStylesView, ToggleStyle Custom")
                    }
                    
                    NavigationLink {
                        ScrollingHStack()
                    } label: {
                        Text("ScrollingHStack")
                    }
                    
                    NavigationLink {
                        NotificationBanner()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("NotificationBanner")
                                .font(.title)
                            Text("一个简单易用的通知横幅为SwiftUI使用ViewModifier")
                                .font(.body)
                        }
                    }
                    
                    NavigationLink {
                        ScrollViewStickyHeader()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("ScrollViewStickyHeader")
                                .font(.title)
                            Text("介绍如何在你的ScrollView顶部实现一个 Sticky Header。学习如何将它与 Image 和 Custom View 一起使用。")
                                .font(.body)
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        CubeRotationTransition()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Cube Rotation Transition")
                                .font(.title)
                            Text("介绍如何在你的ScrollView顶部实现一个 Sticky Header。学习如何将它与 Image 和 Custom View 一起使用。")
                                .font(.body)
                        }
                    }
                    
                    NavigationLink {
                        LikeModifierView()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("LikeModifier ")
                                .font(.title)
                            Text("介绍如何在你的ScrollView顶部实现一个 Sticky Header。学习如何将它与 Image 和 Custom View 一起使用。")
                                .font(.body)
                        }
                    }
                    
                    
                }
                
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .navigationTitle(Text("列表"))
        }
        .navigationViewStyle(.stack)
        
    }
}

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab()
    }
}
