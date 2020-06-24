//
//  WebView.swift
//  00657025_final
//
//  Created by User20 on 2020/6/15.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var station: Station
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = station.StationURL {
            let https = "https" + url.dropFirst(4)
            let request = URLRequest(url: URL(string: https)!)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    typealias UIViewType = WKWebView
}
