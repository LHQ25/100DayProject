//
//  NotificationBanner.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/8.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    
    struct BannerData {
        var title: String
        var detail: String
        
        var type: BannerType
        
        enum BannerType {
            case Info
            case Warning
            case Success
            case Error

            var tintColor: Color {
                switch self {
                case .Info:
                    return Color(red: 67/255, green: 154/255, blue: 215/255)
                case .Success:
                    return Color.green
                case .Warning:
                    return Color.yellow
                case .Error:
                    return Color.red
                }
            }
        }
    }
    
    @Binding
    var data: BannerData
    
    @Binding
    var show:Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(data.type.tintColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
            }
        }
    }
}

extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        modifier(BannerModifier(data: data, show: show))
    }
}

struct NotificationBanner: View {
    
    @State
    var showBanner:Bool = false
    @State
    var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "Default Title", detail: "This is the detail text for the action you just did or whatever blah blah blah blah blah", type: .Success)
        
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Button(action: {
                self.bannerData.type = .Info
                self.showBanner = true
            }) {
                Text("[ Info Banner ]")
            }
            Button(action: {
                self.bannerData.type = .Success
                self.showBanner = true
            }) {
                Text("[ Success Banner ]")
            }
            Button(action: {
                self.bannerData.type = .Warning
                self.showBanner = true
            }) {
                Text("[ Warning Banner ]")
            }
            Button(action: {
                self.bannerData.type = .Error
                self.showBanner = true
            }) {
                Text("[ Error Banner ]")
            }
        }.banner(data: $bannerData, show: $showBanner)
    }
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner()
    }
}
