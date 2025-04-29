//
//  LoginSelectionButtons.swift
//  Kulushae
//
//  Created by ios on 12/10/2023.
//

import SwiftUI

struct LoginSelectionButtons: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State var titleVal: String = "abx"
    @State var imageName: String = "apple"
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(imageName)
            Text(LocalizedStringKey(titleVal))
                .font(.roboto_14())
                .fontWeight(.medium)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding()
                .foregroundColor(Color.black)
            Spacer()
        }
        .frame(height: 48)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke( Color.unselectedBorderColor , lineWidth: 1))
    }
}



#Preview {
    LoginSelectionButtons()
}
