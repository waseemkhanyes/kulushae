//
//  RecentCarAdsNewView.swift
//  Kulushae
//
//  Created by Waseem  on 10/11/2024.
//

import SwiftUI
import Kingfisher
struct RecentCarAdsNewView: View {
    
    @Binding var advList: [PostedCars]
    @Binding var isSelectedId: Int
    @Binding var selectedType: String
    @Binding var isSelected: Bool
    @Binding var isFavourite: Bool
    @Binding var isLoginSheetPresented: Bool
    @Binding var isFavClicked: Bool
    
    @EnvironmentObject var languageManager: LanguageManager
    var action: ((PostedCars)->())
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(advList.indices, id: \.self) { index in
                    Button {
                        action(advList[index])
//                        selectedType = advList[index].type ?? ""
//                        isSelected = true
//                        isSelectedId = advList[index].id ?? -1
//                        print("criticl",isSelectedId, index, advList[index].title, advList[index].id )
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Spacer()
                                KFImage(URL(string: (Config.imageBaseUrl) + (advList[index].images?.first?.image ?? "")))
                                    .placeholder {
                                        Image("default_property")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 163, height: 135)
                                            .cornerRadius(15, corners: [.topLeft, .topRight])
                                            .clipped()
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 163, height: 135)
                                    .cornerRadius(15, corners: [.topLeft, .topRight])
                                    .clipped()
                                
                                Spacer()
                            }
                            HStack(spacing: 5) {
                                Text(String(format: "%.0f", advList[index].price ?? 0.0))
                                    .font(.roboto_20())
                                    .font(.headline.weight(.semibold))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.black)
                                
                                Text(LocalizedStringKey("AED"))
                                    .font(.roboto_20())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .font(.headline.weight(.semibold))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.black)
                            }
                            .padding(.leading, 15)
                            
                            Text(advList[index].title ?? "")
                                .padding(.leading, 15)
                                .font(.roboto_16())
                                .font(.headline.weight(.thin))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.black)
                            
                            HStack(spacing: 5) {
                                Image("location_pin")
                                    .padding(.leading, 15)
                                
                                Text(advList[index].emirates ?? "")
                                    .font(.roboto_14())
                                    .font(.headline.weight(.semibold))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.gray)
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        .overlay() {
                            HStack(spacing: 20) {
                                Spacer()
                                Button {
                                    if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                        selectedType = advList[index].type ?? ""
                                        if(advList[index].isFavorite ?? false) {
                                            advList[index].isFavorite = false
                                            isFavourite = false
                                        } else {
                                            advList[index].isFavorite = true
                                            isFavourite = true
                                        }
                                        isSelectedId = advList[index].id ?? -1
                                        isFavClicked = true
                                    } else {
                                        isLoginSheetPresented = true
                                    }
                                } label: {
                                    Image( (advList[index].isFavorite ?? false) ? "whish_filled" :  "wish")
                                }
                                .frame(width: 30, height: 30)
                                .zIndex(2.0)
                            }
                            .padding(.horizontal, 15)
                            .offset(y: -103)
                        }
                    }
                    .frame(width: 163, height: 246)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#F4F4F4"), lineWidth: 1)
                            .shadow(radius: 5)
                    )
                }
            }
        }
    }
}

//#Preview {
//    RecentCarAdsNewView()
//}
