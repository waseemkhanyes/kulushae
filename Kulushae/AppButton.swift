//
//  AppButton.swift
//  Kulushae
//
//  Created by ios on 12/10/2023.
//

import SwiftUI

struct AppButton: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    @State var titleVal: String  = "name"
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Text(LocalizedStringKey(titleVal))
                .font(.roboto_16_bold())
                .multilineTextAlignment(.center)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding(.vertical)
                .foregroundColor(isSelected ? Color.white : Color.black)
            Spacer()
        }
       
        .background(isSelected ?  Color.appPrimaryColor : Color.white)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
             .stroke(isSelected ?  Color.clear : Color.unselectedBorderColor )
        )
        .padding(.horizontal, 10)
    }
}

#Preview {
    AppButton( isSelected: .constant(false))
}
