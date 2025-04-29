//
//  MotorQuickLinksItemView.swift
//  Kulushae
//
//  Created by Waseem  on 29/12/2024.
//


import SwiftUI
import SDWebImageSwiftUI

struct MotorQuickLinksItemView: View {
    
    var categories: [JSON] = []
    @EnvironmentObject var languageManager: LanguageManager
    
    var onClickSubCtg: ((JSON) -> Void)? = nil // Callback to handle selection
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10.0) {
                ForEach(categories, id: \.dictionaryValue["id"]?.intValue) { category in
                    subCategoryView(category)
                }
            }
        }
    }
    
    func subCategoryView(_ item: JSON) -> some View {
        VStack(alignment: .center, spacing: 0) {
            cachedWebImage(urlString: Config.imageBaseUrl + (item["icon"].stringValue))
                .frame(width: 72, height: 72)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(hex: "#c2c2c2"), lineWidth: 1)
                )
                .padding(1)
            
            Text(LocalizedStringKey(item["title"].stringValue))
                .font(.Roboto.Medium(of: 14))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                .padding(.top, 6)
        }
        .onTapGesture {
            onClickSubCtg?(item)
        }
    }
}

#Preview {
    MotorQuickLinksItemView()
}
