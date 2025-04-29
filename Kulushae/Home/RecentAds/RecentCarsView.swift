//
//  RecentCarsView.swift
//  Kulushae
//
//  Created by ios on 29/03/2024.
//

import SwiftUI

struct RecentCarsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var carList: [PostedCars]
    @Binding var isSelectedId: Int
    @Binding var selectedType: String
    @Binding var isSelected: Bool
    @Binding var isFavourite: Bool
    @Binding var isLoginSheetPresented: Bool
    @Binding var isFavClicked: Bool
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(carList.indices, id: \.self) { index in
                    Button {
                        selectedType = carList[index].type ?? ""
                        isSelected = true
                        isSelectedId = carList[index].id ?? -1
                    } label : {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Spacer()
                                AsyncImage(url: URL(string: (Config.imageBaseUrl) + (carList[index].images?.first?.image ?? ""))) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 163, height: 135)
                                        .cornerRadius(15, corners: [.topLeft, .topRight])
                                        .clipped()
                                } placeholder: {
                                    Image("default_property")
                                        .resizable()
                                        .frame(width: 163, height: 135)
                                        .cornerRadius(15, corners: [.topLeft, .topRight])
                                }
                                Spacer()
                            }
                            HStack(spacing: 5) {
                                Text(String(format: "%.0f", carList[index].price ?? 0.0))
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
                            Text(carList[index].title ?? "")
                                .padding(.leading, 15)
                                .font(.roboto_16())
                                .font(.headline.weight(.thin))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.black)
                            
                            HStack(spacing: 5){
                                Image("location_pin")
                                    .padding(.leading, 15)
                                Text(LocalizedStringKey(carList[index].emirates ?? ""))
                                    .font(.roboto_14())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
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
                                    selectedType = carList[index].type ?? ""
                                    if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                        if(carList[index].isFavorite ?? false) {
                                            carList[index].isFavorite = false
                                            isFavourite = false
                                        } else {
                                            carList[index].isFavorite = true
                                            isFavourite = true
                                        }
                                        isSelectedId = carList[index].id ?? -1
                                        isFavClicked = true
                                    } else {
                                        isLoginSheetPresented = true
                                    }
                                } label: {
                                    Image( (carList[index].isFavorite ?? false) ? "whish_filled" :  "wish")
                                }
                                .frame(width: 30, height: 30)
                                .zIndex(2.0)
                            }
                            .padding(.trailing, 15)
                            .offset(y: -103)
                        }
                    }
                    .frame(width: 163, height: 246)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 0.5)
                            .shadow(radius: 5)
                    )
                }
            }
        }
    }
    
    
}
