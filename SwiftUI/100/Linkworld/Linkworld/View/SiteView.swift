//
//  SiteView.swift
//  Linkworld
//
//  Created by 9527 on 2022/12/7.
//

import SwiftUI
import WebKit

struct SiteView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    var indexUrl: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {

        if let url = URL(string: indexUrl) {
            uiView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> WebCoordinator {
        WebCoordinator()
    }
    
    class WebCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            debugPrint("加载完成")
        }
    }
    
}
