//
//  TextWithImageAndPlaceholderView.swift
//  Kulushae
//
//  Created by ios on 01/12/2023.
//

import SwiftUI

struct TextWithImageAndPlaceholderView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State var image: String
    @State var placeholder: String 
    @Binding var value: String?
    
    var body: some View {
        HStack {
            Image(image)
                .foregroundColor(Color.gray)
            VStack(alignment: .leading, spacing: 10) {
                Text(LocalizedStringKey(placeholder))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                Text(LocalizedStringKey(value ?? "Not Available"))
                    .font(.roboto_16())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame( height: 1)
                    .background(.black.opacity(0.1))
            }
        }
    }
}

//#Preview {
//    TextWithImageAndPlaceholderView()
//}
