//
//  GifViewer.swift
//  Marvel
//
//  Created by Vasilis Polyzos on 6/7/25.
//

import Foundation
import SwiftUI
import WebKit

struct GifViewer: UIViewRepresentable {
    private let gif: String
    
    init(gif: String) {
        self.gif = gif
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: gif, withExtension: "gif")
        guard let url else { return WKWebView()}
        do {
            let data = try Data(contentsOf: url)
            webview.load( data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
            webview.scrollView.isScrollEnabled = false
            webview.isOpaque = false
        }
        catch {
            print("Error")
        }
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
