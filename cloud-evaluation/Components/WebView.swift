//
//  WebView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false // Make the web view transparent
        webView.backgroundColor = .clear // Set background color to clear
        webView.scrollView.backgroundColor = .clear // Set scroll view background to clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Wrap the HTML in a style to ensure the background is transparent
        let transparentHTML = """
        <html>
            <head>
                <style>
                    body {
                        background-color: transparent !important;
                        color: black; /* Set text color if needed */
                        margin: 0;
                        padding: 0;
                    }
                </style>
            </head>
            <body>
                \(html)
            </body>
        </html>
        """
        uiView.loadHTMLString(transparentHTML, baseURL: nil)
    }
}
