//
//  ImageTopDataBottomViewWithDot.swift
//  Kulushae
//
//  Created by ios on 22/11/2023.
//


import SwiftUI

struct ImageTopDataBottomViewWithDot: View {
    @EnvironmentObject var languageManager: LanguageManager

    var text: String
    var image: String
    var isSelected: Bool

    var body: some View {
        VStack {
            Image(image)
                .foregroundColor(.black)
                .overlay(
                    isSelected
                        ? Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 5, height: 5)
                            .foregroundColor(.black)
                            .offset(x: 15, y: -15) // Adjust the position of the dot
                        : nil
                )
            Text(LocalizedStringKey(text))
                .foregroundColor(Color.black)
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.unselectedBorderColor))
        }
        .frame(height: 50)
    }
}


