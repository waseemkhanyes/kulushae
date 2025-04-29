//
//  SelectionButton.swift
//  Kulushae
//
//  Created by ios on 20/10/2023.
//

import SwiftUI

import SwiftUI

struct SelectionButton: View {
    
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
                .foregroundColor(Color.black )
            
            Spacer()
        }
        .frame(height: 40)
        .background(isSelected ?  Color.selectedTextBackgroundColor : Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
             .stroke(isSelected ?  Color.clear : Color.selectedTextBackgroundColor )
        )
    }
}

#Preview {
    AppButton( isSelected: .constant(false))
}
