//
//  SubCategoryNewView.swift
//  Kulushae
//
//  Created by Waseem  on 09/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SubCategoryNewView: View {
    
    var categories: [CategoryListModel] = []
    @EnvironmentObject var languageManager: LanguageManager
    
    var onClickSubCtg: ((CategoryListModel) -> Void)? = nil // Callback to handle selection
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10.0) {
                ForEach(categories, id: \.self) { category in
                    subCategoryView(category)
                }
            }
        }
    }
    
    func subCategoryView(_ item: CategoryListModel) -> some View {
        VStack(alignment: .center, spacing: 0) {
            cachedWebImage(urlString: Config.imageBaseUrl + (item.image ?? ""))
                .frame(width: 72, height: 72)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(hex: "#c2c2c2"), lineWidth: 1)
                )
                .padding(1)
            
            Text(LocalizedStringKey(item.title ?? ""))
                .font(.roboto_14_Medium())
                .fontWeight(.bold)
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
    SubCategoryNewView()
}
