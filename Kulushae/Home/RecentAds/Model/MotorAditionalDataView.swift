//
//  MotorAditionalDataView.swift
//  Kulushae
//
//  Created by ios on 29/03/2024.
//

import SwiftUI

struct MotorAditionalDataView: View {
    @EnvironmentObject var languageManager: LanguageManager
    var title: String = ""
    var value: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text(LocalizedStringKey(title))
                .font(.roboto_14())
                .foregroundColor(.black)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding(.horizontal, 5)
            Text(LocalizedStringKey(value))
                .font(.roboto_16_bold())
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding(.horizontal, 5)
        }
        .frame(height: 52)
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    MotorAditionalDataView()
}
