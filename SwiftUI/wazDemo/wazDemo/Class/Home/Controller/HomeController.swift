//
//  HomeController.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/14.
//

import SwiftUI
import Combine
import Introspect

struct HomeController: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    @Environment(\.viewController) private var viewControllerHolder:
    ViewControllerHolder

    private var viewController: UIViewController? {
        self.viewControllerHolder.value
    }
    
    var body: some View {
        
//        NavigationView {
            RefreshableScrollView(height: 54,
                                  refreshing: viewModel.refreshing,
                                  bottomRefreshable: true,
                                  showNoMoreData: $viewModel.showNoMoreData,
                                  showBottomLoading: viewModel.showBottomLoading,
                                  noDataPrompt: "noDataPrompt")
            {
                
                if viewModel.viewData.banner.count != 0 {
                    HomeSDCView(banners: viewModel.viewData.banner)
                        .frame(height: 200)
                }
                ForEach(viewModel.viewData.artic) { res in
                    
//                    NavigationLink(
//                        destination: DetailView(webUrl: res.link),
//                        label: {
                            HomeArticView(title: res.title, time: res.niceDate)
                                .onTapGesture {
                                    self.viewController?.push(builder: {
                                        DetailView(webUrl: res.link)
                                    })
                                }
                                
//                        })
//                        .isDetailLink(true)
                        
                }
            }
//        }
//        .navigationBarTitle("首页", displayMode: .inline)
//        .navigationBarItems(trailing: Image(systemName: "magnifyingglass")
//                                .onTapGesture { })

//        .onAppear(){
//            viewModel.articData()
//        }
    }
}

//struct HomeController_p: PreviewProvider {
//
//
//    static var previews: some View {
//        HomeController()
//    }
//
//}
