//
//  HomeViewModel.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/15.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: NSObject {
    
    @Published var viewData: (artic: [HomeArticListModel], banner: [HomeBannerModel]) = ([],[])
    
    private var _refreshing = false
    lazy var refreshing: Binding<Bool> = .init {
        return self._refreshing
    } set: { v in
        if self._refreshing != v {
            self._refreshing = v
            self.banner.send(())
            self.topArtic.send(())
            self.loadNormal.send(1)
        }
    }

    @State var showNoMoreData = false
    
    private var _showBottomLoading = false
    lazy var showBottomLoading: Binding<Bool> = .init {
        return self._showBottomLoading
    } set: { v in
        if self._showBottomLoading != v {
            self._showBottomLoading = v
            let page = self.loadNormal.value + 1
            self.loadNormal.send(page)
        }
    }
    
    private var cancellables = [Cancellable]()
     
    private var articList = [HomeArticListModel]()
    
    private let banner = CurrentValueSubject<Void, Never>(())
    private let topArtic = CurrentValueSubject<Void, Never>(())
    private let loadNormal = CurrentValueSubject<Int, Never>(1)
    
    
    override init() {
        super.init()
        
        articData()
    }
    
    private func articData() {
        
        let bannerlable = banner.flatMap { _ in
            Net.request(request: HomeApi.banner)
                .convertArrayObject(type: [HomeBannerModel].self, keyPath: "data")
        }
        
        let cancellable = topArtic.flatMap { _ in
            Net.request(request: HomeApi.articList)
                .convertArrayObject(type: [HomeArticListModel].self, keyPath: "data")
        }
        
        let normalCancellable = loadNormal.flatMap {
            Net.request(request: HomeApi.articNormalList(page: $0))
                .convertObject(type: ArticBaseModel.self)
        }
        
        let viewDataLables = bannerlable.combineLatest(cancellable, normalCancellable)
            .sink { [weak self] complete in
                switch complete {
                case let .failure(e):
                    print("失败：\(e)")
                    self?._refreshing = false
                    self?._showBottomLoading = false
                case .finished:
                    self?._refreshing = false
                    self?._showBottomLoading = false
                }
            } receiveValue: { [weak self] banner, artic, normal in
                
                self?.viewData.banner = banner
                if self?.loadNormal.value == 1 {
                    self?.viewData.artic = artic + normal.data.datas
                }else {
                    self?.viewData.artic.append(contentsOf: normal.data.datas)
                }
                
                self?._refreshing = false
                self?._showBottomLoading = false
            }
        
        banner.send(())
        topArtic.send(())
        
        cancellables.append(viewDataLables)
    }
    
    deinit {
        cancellables.forEach { cl in
            cl.cancel()
        }
    }
}

extension HomeViewModel: ObservableObject {
    
}
