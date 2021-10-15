//
//  HomeSDCView.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/16.
//

import SwiftUI
import Kingfisher

struct HomeSDCView: View {
    
    var banners: [HomeBannerModel]
    
    var body: some View {
        GeometryReader { gr in
            
            SDCView(banners: banners)
                .frame(width: gr.size.width, height: gr.size.height)
        }
    }
}


struct SDCView: UIViewRepresentable {
    typealias UIViewType = FSPagerView
    typealias Coordinator = SDCView.Coordinator_a
    private let pageView = FSPagerView()
    
    var banners: [HomeBannerModel]
    
    func makeUIView(context: Context) -> FSPagerView {
        
        pageView.automaticSlidingInterval = 3
        pageView.scrollDirection = .horizontal
        pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "SDCCell")
        return pageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        
        Coordinator(bannerView: pageView, banners: banners)
    }
    
    class Coordinator_a: NSObject, FSPagerViewDataSource, FSPagerViewDelegate {
        
        private var banners: [HomeBannerModel]!
        var bannerView: FSPagerView!
        
        init(bannerView: FSPagerView, banners: [HomeBannerModel]) {
            super.init()
            
            self.bannerView = bannerView
            self.bannerView.delegate = self
            self.bannerView.dataSource = self
            
            self.banners = banners
        }
        
        func numberOfItems(in pagerView: FSPagerView) -> Int {
            banners.count
        }
        
        func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
            
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SDCCell", at: index)
            cell.imageView?.kf.setImage(with: URL(string: banners[index].imagePath))
            return cell
        }
    }
}
