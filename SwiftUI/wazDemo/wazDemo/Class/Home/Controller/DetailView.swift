//
//  DetailView.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/21.
//

import SwiftUI
import WebKit

struct DetailView: View {
    
    var webUrl: URL
    
    var body: some View {
        
        WebView(url: webUrl)
    }
}

// MARK: - WebView
struct WebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
//    typealias Coordinator = WebView.Coordinator_a
    var url: URL
    
    private let wb = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        wb.load(URLRequest(url: url))
        return wb
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        uiView.reload()
    }
    
//    func makeCoordinator() -> Coordinator {
//
//        Coordinator(bannerView: pageView, banners: banners)
//    }
    
//    class Coordinator_a: NSObject, FSPagerViewDataSource, FSPagerViewDelegate {
//
//        private var banners: [HomeBannerModel]!
//        var bannerView: FSPagerView!
//
//        init(bannerView: FSPagerView, banners: [HomeBannerModel]) {
//            super.init()
//
//            self.bannerView = bannerView
//            self.bannerView.delegate = self
//            self.bannerView.dataSource = self
//
//            self.banners = banners
//        }
//
//        func numberOfItems(in pagerView: FSPagerView) -> Int {
//            banners.count
//        }
//
//        func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//
//            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SDCCell", at: index)
//            cell.imageView?.kf.setImage(with: URL(string: banners[index].imagePath))
//            return cell
//        }
//    }
}
