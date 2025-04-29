//
//  PropertyView.swift
//  Kulushae
//
//  Created by ios on 23/10/2023.
//

import SwiftUI

struct PropertyView: View {
    @StateObject var dataHandler = HomeViewModel.ViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State var isRentEnabled: Bool = true
    @State var isSellerEnabled: Bool = false
    @Binding var catId: Int
//    @State var categories: [CategoryListModel] = []
    @State var selectedCategory: String  = ""
    @State var newCatIdVal = -1
    @State private var isNavigationActive = false
    @State var parentCategoryId = -4
    @State var isOpenDetails: Bool = false
    var serviceType: ServiceType

//    var onCatIdChanged: ((Int?) -> Void) = { _ in
//    }
    
    var titleVal: String  = ""
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    NavigationTopBarView(titleVal: titleVal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    categoriesView
                        .padding(.horizontal, 20)
                    
//                    CategoryChildView(categories: $dataHandler.categoryObject, onCatIdChanged: { newCatId, isToNext, title   in
//                        newCatIdVal = newCatId ?? -2
//                        selectedCategory = title
//                        if(isToNext) {
//                            withAnimation() {
//                                isNavigationActive = true
//                            }
//                        } else {
//                            withAnimation() {
//                                isOpenDetails = true
//                            }
//                        }
//                    })
//                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity)
            }
            .onAppear() {
                dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(catId: catId, showOnScreen: 0))
//                AdDetailsView.fieldValueArray = []
            }
        }
        
        NavigationLink("", destination: PropertyView(catId: .constant(newCatIdVal), parentCategoryId: parentCategoryId, serviceType: serviceType, titleVal: selectedCategory), isActive: $isNavigationActive)
//        NavigationLink("", destination: AdDetailsView(openedStates: [],  newCatIdVal: newCatIdVal,  titleVal: selectedCategory, stepNum: 1), isActive: $isOpenDetails)
        NavigationLink("", destination: CreateAdsFormView(dataHandler: .init(title: selectedCategory, newCatIdVal: newCatIdVal, stepNum: 1, parentCatIdVal: parentCategoryId, serviceType: serviceType)), isActive: $isOpenDetails)
            .navigationBarBackButtonHidden(true)
    }
    
    var categoriesView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(dataHandler.categoryObject, id: \.self) { category in
                    categoryItemView(category)
                }
            }
        }
        .padding(.top, 5)
    }
    
    func categoryItemView(_ category: CategoryListModel) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(LocalizedStringKey(category.title ?? ""))
                    .font(.roboto_16())
                    .fontWeight(.medium)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                
                Spacer()
                
                if category.has_child ?? false {
                    Image("arrow_forword")
                        .frame(width: 22, height: 22)
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                }
            }
            .padding(.vertical)
            
            VStack(spacing: 0) {}
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.3))
            
        }
        .onTapGesture {
            if(category.has_form) {
//                AdDetailsView.parentCatIdVal = Int(category.id)  ?? -4
                parentCategoryId = Int(category.id)  ?? -4
            }
            print("** wk categoryId: \(category.id)")
            self.newCatIdVal = Int(category.id)  ?? -1
            self.selectedCategory = trim(category.title)
            
            if category.has_child ?? false {
                isNavigationActive = true
            } else {
                isOpenDetails = true
            }
        }
//        .background {
//            RoundedRectangle(cornerRadius: 0)
//                .stroke(.black.opacity(0.5), lineWidth: 1.0)
//        }
//        .padding(1)
    }
}

//#Preview {
//    PropertyView()
//}
