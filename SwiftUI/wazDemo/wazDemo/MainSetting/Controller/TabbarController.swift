//
//  TabbarController.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/14.
//

import SwiftUI

struct MainTabbarController: View {
    
    let cs = ColorScheme.dark
//    var rab =
    var body: some View {
        
//        NavigationView{
            TabView {
                NavigationView{
                    HomeController()
                        .navigationBarTitle("首页", displayMode: .inline)
                        .navigationBarItems(trailing: Image(systemName: "magnifyingglass") .onTapGesture { })
                }
                .tabItem { TabItemView(image: "home", title: "首页") }
                .tag(0)
                
                HomeController()
                    .tabItem { TabItemView(image: "home", title: "知识") }
                    .tag(1)
                
                HomeController()
                    .tabItem {
                        Text("首页3")
                    }.tag(2)
                
                HomeController()
                    .tabItem {
                        Text("首页4")
                    }.tag(3)
                
                HomeController()
                    .tabItem {
                        Text("首页5")
                    }.tag(4)
            }
            
//            .navigationBarTitle("首页", displayMode: .inline)
//            .navigationBarItems(trailing: Image(systemName: "magnifyingglass")
//                                    .onTapGesture { })
        
        }
}

//struct TabbarController_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabbarController()
//    }
//}

// MARK: -
struct TabItemView: View {
    
    var image: String
    var title: String
    
    var body: some View {
        VStack {
            Image(image)
                .renderingMode(.original)
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.red)
        }
    }
}

class TabbarState: ObservableObject {
    
    @Published var isHidden = false
}


struct MyTabbarController: UIViewControllerRepresentable {
    
    
    typealias UIViewControllerType = UITabBarController
    typealias Coordinator = MyCoordinator
    
    private var tabbarController = UITabBarController()
    
    func makeUIViewController(context: Context) -> UITabBarController {
        
        let homeVC = UIHostingController(rootView: NavigationView(content: {
                                                                    HomeController().navigationBarTitle("首页", displayMode: .inline)
                                                                        .navigationBarItems(trailing: Image(systemName: "magnifyingglass") .onTapGesture { })}))
        homeVC.tabBarItem.title = "首页"
        homeVC.tabBarItem.image = UIImage(named: "home")!
        homeVC.hidesBottomBarWhenPushed = true
        tabbarController.addChild(homeVC)
        
        let homeVC2 = UIHostingController(rootView: HomeController())
        homeVC2.tabBarItem.title = "首页2"
        homeVC2.tabBarItem.image = UIImage(named: "home")!
        tabbarController.addChild(homeVC2)
        
        tabbarController.tabBar.backgroundColor = .white
//        tabbarController.tabBar.isTranslucent = false
        return tabbarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        MyCoordinator()
    }
    
    struct MyCoordinator {
        
    }
    
}
