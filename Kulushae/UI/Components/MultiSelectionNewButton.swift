//
//  MultiSelectionNewButton.swift
//  Kulushae
//
//  Created by Waseem  on 29/11/2024.
//

import SwiftUI

struct MultiSelectionNewButton: View {
    
    @EnvironmentObject var languageManager: LanguageManager
    
    var title: String  = "name"
    var isSelected: Bool
    var action: ()->Void
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.roboto_14())
                .lineLimit(1)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                .multilineTextAlignment(.leading)
                .foregroundColor(isSelected ? Color.white : Color.black)
                .padding(.horizontal)
//                .frame(maxWidth: .infinity)
            
            if isSelected {
                Image("tick")
                    .padding(.leading, 0)
                    .padding(.trailing)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 40)
//        .frame(maxWidth: .infinity)
        .background(isSelected ?  Color.iconSelectionColor : Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(isSelected ? Color.clear : Color.unselectedBorderColor )
        )
        .onTapGesture {
            action()
        }
    }
}
