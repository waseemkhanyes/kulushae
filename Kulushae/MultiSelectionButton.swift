//
//  MultiSelectionButton.swift
//  Kulushae
//
//  Created by ios on 08/11/2023.
//

import SwiftUI
struct MultiSelectionButton: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    @State var titleVal: String  = "name"
    @Binding var isSelected: Bool
    @Binding var selectedArray : [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(LocalizedStringKey(titleVal))
                .font(.roboto_14())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .multilineTextAlignment(.leading)
                .foregroundColor(selectedArray.contains(titleVal) ? Color.white : Color.black)
                .padding(.horizontal)
            if(selectedArray.contains(titleVal)) {
                Image("tick")
                    .padding(.leading, 0)
                    .padding(.trailing)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 40)
        .background(selectedArray.contains(titleVal) ?  Color.iconSelectionColor : Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(selectedArray.contains(titleVal) ?  Color.clear : Color.unselectedBorderColor )
        )
    }
}
