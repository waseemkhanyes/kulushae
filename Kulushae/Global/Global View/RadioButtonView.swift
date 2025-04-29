//
//  RadioButtonView.swift
//  Kulushae
//
//  Created by ios on 07/11/2023.
//

import SwiftUI

struct RadioButtonView: View {
    var title: String
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedVal: String
    var body: some View {
        Button(action: {
            selectedVal = title
        }) {
            HStack {
                Image(self.selectedVal == self.title ? "icn_radio_selected" : "notselectedradio")
                    .foregroundColor(.black)
                
                Text(LocalizedStringKey(title))
                    .font(.roboto_14())
                    .multilineTextAlignment(.leading)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
    }
}


struct RadioButtonCategoryView: View {
    var item: CategoryListModel
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedId: String
    var body: some View {
        Button(action: {
            selectedId = item.id
        }) {
            HStack {
                Image(self.selectedId == item.id ? "check_box" : "rectangle_box")
                    .foregroundColor(.black)
                
                Text(LocalizedStringKey(item.title ?? ""))
                    .font(.roboto_14())
                    .multilineTextAlignment(.leading)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
    }
}

struct MultiRadioView: View {
    var item: String
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedItem: String
    var body: some View {
        Button(action: {
            selectedItem = item
        }) {
            HStack {
                Image(self.selectedItem == item ? "check_box" : "rectangle_box")
                    .foregroundColor(.black)
                
                Text(LocalizedStringKey(item))
                    .font(.roboto_14())
                    .multilineTextAlignment(.leading)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
    }
}
