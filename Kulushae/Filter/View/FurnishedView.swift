//
//  FurnishedView.swift
//  Kulushae
//
//  Created by ios on 13/02/2024.
//

import SwiftUI

struct FurnishedView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedFurnished: FurnishedModel
    let furnishedList = ["All", "Furnished", "Unfurnished"]
    
    var body: some View {
        HStack() {
            ForEach(furnishedList, id: \.self) { type in
                Button(action: {
                    // Update selectedFurnished based on the selected type
                    switch type {
                    case "All":
                        selectedFurnished = .all
                    case "Furnished":
                        selectedFurnished = .fullyFurnished
                    case "Unfurnished":
                        selectedFurnished = .unfurnished
                    default:
                        break
                    }
                }) {
                    Text(LocalizedStringKey(type))
                        .font(.roboto_14())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(selectedFurnished == furnishingType(from: type) ? .white : Color.black)
                    
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedFurnished == furnishingType(from: type) ? Color.iconSelectionColor : Color.unselectedBorderColor, lineWidth: 1)
                        )
                        .background(selectedFurnished == furnishingType(from: type) ? Color.iconSelectionColor : Color.clear)
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
    }
    
    func furnishingType(from string: String) -> FurnishedModel {
        switch string {
        case "All":
            return .all
        case "Furnished":
            return .fullyFurnished
        case "Unfurnished":
            return .unfurnished
        default:
            return .all
        }
    }
}

