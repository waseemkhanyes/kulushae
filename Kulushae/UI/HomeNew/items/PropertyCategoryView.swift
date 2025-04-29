//
//  PropertyCategoryView.swift
//  Kulushae
//
//  Created by Waseem  on 12/11/2024.
//

import SwiftUI

struct PropertyCategoryView: View {
    @ObservedObject var viewModel: HomeViewNewModel.ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            if !viewModel.arraySubCategory.isEmpty {
//                subCategoryView
//            }
//            
//            if !viewModel.arrayAdvObject.isEmpty {
//                propertiesSection
//            }
        }
    }
}

#Preview {
    PropertyCategoryView(viewModel: .init(language: LanguageManager.init().currentLanguage))
}
