//
//  PopOverView.swift
//  Kulushae
//
//  Created by ios on 03/11/2023.
//

import SwiftUI

struct PopoverView: View {
    var text: String
    @EnvironmentObject var languageManager: LanguageManager
    var body: some View {
        VStack {
            Text(LocalizedStringKey(text))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .frame( height: 50)
    }
}
