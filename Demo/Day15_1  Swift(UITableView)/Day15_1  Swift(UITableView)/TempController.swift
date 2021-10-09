//
//  TempController.swift
//  Day15_1  Swift(UITableView)
//
//  Created by 亿存 on 2020/7/29.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit
import WebKit


class TempController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
        let webView = WKWebView(frame: self.view.bounds, configuration: WKWebViewConfiguration())
        view.addSubview(webView)
        
        webView.load(URLRequest(url: URL(string: "https://www.jianshu.com/p/6b252f52b51d")!))
        
    }
}
