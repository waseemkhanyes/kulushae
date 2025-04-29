//
//  SingleSelectionView.swift
//  Kulushae
//
//  Created by ios on 09/02/2024.
//

import SwiftUI

struct SingleSelectionView: View {
    let item: CategoryListModel
    @Binding var selectedItemId: String
    @EnvironmentObject var languageManager: LanguageManager
    
    
    var body: some View {
        Button(action: {
            selectedItemId = item.id
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(item.id == selectedItemId ? Color.iconSelectionColor : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .inset(by: 0.5)
                            .stroke(item.id == selectedItemId ? Color.clear : .black, lineWidth: 1)
                    )
                Text(LocalizedStringKey(item.title ?? ""))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(item.id == selectedItemId ? Color.white : .black)
                    .padding()
            }
        }
    }
}

