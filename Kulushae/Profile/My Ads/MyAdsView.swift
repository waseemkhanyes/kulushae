//
//  MyAdsView.swift
//  Kulushae
//
//  Created by ios on 17/05/2024.
//

import Foundation
import SwiftUI

struct MyAdsView: View {
    
    @StateObject var dataHandler = ProfileViewModel.ViewModel()
    @State var isEditProfileOpen: Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showAlertDeleteProperties = false
    @State var itemsForDelete: [GQLK.DeleteItem] = []
    @State  var selectedProductId: Int = -1
    @State private var isCarDetailViewActive = false
    @State private var isDetailViewActive = false
    @State var pageNumber: Int = 1
    
    @State var isOpenDetails = false
    @State var selectedAdvModel: AdvModel? = nil
    var serviceType: ServiceType {
        return ServiceType(rawValue: trim(selectedAdvModel?.type)) ?? .None
    }
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            if let advModel = selectedAdvModel {
                NavigationLink("", destination: CreateAdsFormView(dataHandler: .init(title: trim(selectedAdvModel?.title), newCatIdVal: 0, stepNum: 1, advData: advModel, serviceType: serviceType)), isActive: $isOpenDetails)
            }
            
            NavigationTopBarView(titleVal: "My Ads", isShowBAckButton: true )
            
            VStack(alignment: .leading) {
                
                MyAdSection
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .cleanNavigationAndSafeArea()
        .onAppear() {
            if let userId = PersistenceManager.shared.loggedUser?.id {
                dataHandler.getAds(userId: Int(userId) ?? 0, page: 1)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder private var MyAdSection: some View {
        
        if(dataHandler.advObject.isEmpty) {
            VStack(alignment: .center) {
                Spacer()
                Text(LocalizedStringKey("No ad Posted yet"))
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .padding(.horizontal, 8)
                    .font(.roboto_20())
                    .font(.headline.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                Spacer()
            }
        } else {
            HStack {
//                DropdownMenuView()
                Spacer()
                Button(action: {
                    showAlertDeleteProperties = true
                }) {
                    Image("delete")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(8)
                }
            }
        }
        
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(dataHandler.advObject.enumerated()), id: \.offset) { index, item in
                        VStack {
                            HStack() {
                                
                                AsyncImage(url: URL(string: (Config.imageBaseUrl) + (item.image ?? ""))) { image in
                                    image
                                        .resizable()
                                        .frame(width: 100,  height: 100)
                                        .scaledToFill()
                                        .cornerRadius(15)
                                } placeholder: {
                                    Image("default_property")
                                        .resizable()
                                        .frame(width: 100,  height: 100)
                                        .cornerRadius(15)
                                        .padding(.top, 5)
                                }
                                
                                VStack {
                                    Spacer()
                                    Text(item.title ?? "" )
                                        .padding(.horizontal, 8)
                                        .font(.roboto_16())
                                        .font(.headline.weight(.semibold))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(Color.black)
                                    Spacer()
                                }
                                Spacer()
                                
                                Button(action: {
                                    selectedAdvModel = dataHandler.advObject[index]

                                    isOpenDetails = true
                                }) {
                                    VStack(spacing: 0) {
                                        Image(.pencil)
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundStyle(.black.opacity(0.54))
                                            .frame(width: 20, height: 20)
                                    }
                                    .frame(width: 40, height: 40)
                                    .padding(.horizontal, 5)
                                }
                                
                                Image(itemsForDelete.contains { $0.id == (item.id ?? 0) } ? "check_box" : "rectangle_white")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        toggleSelection(GQLK.DeleteItem(id: item.id ?? 0, type: dataHandler.advObject[index].type ?? "") )
                                    }
                            }
                            .onTapGesture {
                                selectedProductId = dataHandler.advObject[index].id ?? -1
                                if let type = dataHandler.advObject[index].type {
                                    if(type.lowercased().contains("motor")) {
                                        isCarDetailViewActive = true
                                    } else {
                                        isDetailViewActive = true
                                    }
                                }
                                
                            }
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 392, height: 1)
                                .background(.black.opacity(0.1))
                                .padding(.vertical, 5)
                            
                        }
                        .onAppear {
                            // Detect when the last item is about to appear
                            if  !dataHandler.advObject.isEmpty {
                                if itemIsLast(item: dataHandler.advObject[index]) {
                                    if(dataHandler.totalPageCount >= pageNumber) {
                                        loadMoreData()
                                    }
                                    
                                    // Scroll to the new bottom item
                                    withAnimation {
                                        scrollViewProxy.scrollTo(dataHandler.advObject.last, anchor: .bottom)
                                    }
                                }
                            }
                            
                        }
                        .alert(isPresented: Binding<Bool>(
                            get: {
                                 showAlertDeleteProperties
                            },
                            set: { newValue in
                                // Handle setting showAlertDelete and showAlertDeleteProperties if needed
                            })
                        ) {
                             if showAlertDeleteProperties {
                                return Alert(
                                    title: Text(LocalizedStringKey("Delete Ads?"))
                                        .font(.roboto_16_bold()),
                                    message: Text(LocalizedStringKey("Are you sure you want to delete selected Ads? This action cannot be undone."))
                                        .font(.roboto_14()),
                                    primaryButton: .destructive(
                                        Text("Delete"),
                                        action: {
                                            deleteProperties()
                                        }
                                    ),
                                    secondaryButton: .cancel {
                                        showAlertDeleteProperties = false
                                    }
                                )
                            } else {
                                return Alert(title: Text(""), message: Text(""))
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(.bottom, -75)
        NavigationLink("", destination: PostedAdDetailsView(productId: selectedProductId) ,
                       isActive: $isDetailViewActive)
        NavigationLink("", destination: CarDetailsView(motorId: selectedProductId) ,
                       isActive: $isCarDetailViewActive)
        .navigationBarBackButtonHidden(true)
    }
    
    private func toggleSelection( _ item: GQLK.DeleteItem) {
        if let index = itemsForDelete.firstIndex(where: { $0.id == item.id }) {
            itemsForDelete.remove(at: index)
        } else {
            itemsForDelete.append(item)
        }
    }
    
    func itemIsLast(item: AdvModel) -> Bool {
        return item == dataHandler.advObject.last
    }
    func loadMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let userId = PersistenceManager.shared.loggedUser?.id {
                dataHandler.getAds(userId: Int(userId) ?? 0, page: pageNumber)
                pageNumber+=1
            }
            
        }
    }
    
    func deleteProperties() {
        dataHandler.isLoading = true
        dataHandler.deleteProperties(idList: itemsForDelete)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dataHandler.advObject.removeAll { item in
                guard let itemId = item.id else {
                    return false
                }
                return  itemsForDelete.contains { $0.id == itemId.graphQLNullable }
            }
            itemsForDelete = []
            dataHandler.isLoading = false
            showAlertDeleteProperties = false
            
        }
    }
}

#Preview {
    MyAdsView()
}
