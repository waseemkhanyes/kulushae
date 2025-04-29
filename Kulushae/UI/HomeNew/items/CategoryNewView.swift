//
//  CategoryNewView.swift
//  Kulushae
//
//  Created by Waseem  on 09/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryNewView: View {
    
    var categories: [CategoryListModel] = []
    @EnvironmentObject var languageManager: LanguageManager
    
    var selected: CategoryListModel? = nil
    
    let hideImage: Bool
    var onCategorySelected: ((CategoryListModel) -> Void)? = nil // Callback to handle selection
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    categoryView(for: category)
                }
            }
            .padding(.horizontal, 10)
        }
    }
    
    private func categoryView(for category: CategoryListModel) -> some View {
        
        let isSelected = selected?.id ?? "" == category.id
        let gbColor = category.bgColor ?? "#BDBFDC"
        let backgroundColor = Color(hex:gbColor) // Background color
        let borderColor = isSelected ? Color(hex: "#FE820E") : Color.clear // Change border color based on selection
        
        return VStack(spacing: 0) {
            if !hideImage {
                imageBackground(for: category)
            }
            
            categoryTitle(for: category)
                .padding(.bottom, hideImage ? 0 : 10)
        }
        .frame(height: hideImage ? 40 : 94) // Set fixed size for the category view
        .frame(minWidth: 94)
        .background(backgroundColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(borderColor, lineWidth: 2) // Set border color
        )
        .padding(.vertical, 1)
        .onTapGesture {
            handleCategoryTap(for: category)
        }
    }
    
    private func imageBackground(for category: CategoryListModel) -> some View {
        cachedWebImage(urlString: Config.imageBaseUrl + (category.image ?? ""))
            .scaledToFit()
            .frame(width: 65, height: 65) // Fixed size for the image
    }
    
    private func categoryTitle(for category: CategoryListModel) -> some View {
        Text(LocalizedStringKey(category.title ?? ""))
            .font(.roboto_14_Medium()) // Font size for title
            .foregroundColor(Color.black)
            .padding(.horizontal, 8)
//            .minimumScaleFactor (0.8) // Allow text to scale down if necessary
    }
    
    private func handleCategoryTap(for category: CategoryListModel) {
        onCategorySelected?(category)
    }
    
}

#Preview {
    CategoryNewView(hideImage: false)
}
