//
//  HTMLStringView.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import SwiftUI
import WebKit

struct HTMLStringView: UIViewRepresentable {        //no SwiftUI mechanism to display html
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {        //renders view to display inside parent
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
