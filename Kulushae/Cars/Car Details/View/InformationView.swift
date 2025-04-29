//
//  InformationView.swift
//  Kulushae
//
//  Created by ios on 01/04/2024.
//

import SwiftUI

struct InformationView: View {
    @EnvironmentObject var languageManager: LanguageManager
    var title = ""
    var value: String
    
    var body: some View {
        Text(LocalizedStringKey(value))
            .font(.Roboto.Regular(of: 14))
            .foregroundColor(Color.black.opacity(0.9))
            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
    }
}

//#Preview {
//    InformationView(title: "add", value: "cfvf")
//}
