//
//  BannerView.swift
//  Kulushae
//
//  Created by ios on 30/01/2024.
//

import SwiftUI
import UIKit

struct BannerViewController: UIViewControllerRepresentable {
    let title: String
    let subtitle: String

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIHostingController(rootView: BannerView(title: title, subtitle: subtitle))
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update the view if needed
    }
}

struct BannerView: View {
    let title: String
    let subtitle: String
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(title))
                .font(.headline)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            Text(subtitle)
                .font(.subheadline)
        }
        .padding()
        .background(Color.accentColor)
        .foregroundColor(.white)
    }
}
