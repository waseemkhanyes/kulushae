//
//  WebView.swift
//  Kulushae
//
//  Created by ios on 22/12/2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
   let url: URL
   
   func makeUIView(context: Context) -> WKWebView {
       let wkwebView = WKWebView()
       let request = URLRequest(url: url)
       wkwebView.load(request)
       return wkwebView
   }
   
   func updateUIView(_ uiView: WKWebView, context: Context) {
   }
}
