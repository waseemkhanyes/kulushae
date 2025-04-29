//
//  CityView.swift
//  Kulushae
//
//  Created by ios on 20/10/2023.
//

import SwiftUI

struct CityView: View {
    @StateObject var locationViewModel: LocationViewModel =  LocationViewModel()
    @Binding var isOpen: Bool
    @EnvironmentObject var languageManager: LanguageManager
//    let city = ["All", "Dubai", "Ajman", "Sharjah", "Abu Dhabi", "Fujairah" , "Umm Al Quwain", "Ras Al Khaimah"]
    var city: [KulushaeCountry]
    
    @Binding var selectedCityName: String
    @Binding var selectedCityId: Int
    @State var currency: String = ""
    var body: some View {
        VStack {
            Text(LocalizedStringKey("Choose the Desire Location"))
                .font(.roboto_22_semi())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.vertical, 25)
                .padding(.horizontal, 20)
            
            ScrollView() {
                VStack(spacing: 10) {
                    ForEach(city.chunked(into: 3), id: \.self) { chunk in
                        HStack(spacing: 10) {
                            ForEach(chunk, id: \.self) { city in
                                SelectionButton(titleVal: city.name ?? "" , isSelected: .constant(selectedCityId == city.id ))
                                    .onTapGesture {
                                        selectedCityId = city.id
                                        selectedCityName = city.name ?? ""
                                        currency = city.currency ?? "pp"
                                        UserDefaultManager.set(selectedCityId, forKey: .choseCityId)
                                        UserDefaultManager.set(selectedCityName, forKey: .choseCityName)
                                        UserDefaultManager.set(selectedCityName, forKey: .choseCityName)
                                        UserDefaultManager.set(currency, forKey: .chosenCurrency)
                                    }
                            }
                        }
                    }
                    .padding(1)
                }
            }
            .padding(.horizontal, 15)
            
            AppButton(titleVal: "Ok", isSelected: .constant(selectedCityId > 0))
                .onTapGesture {
                    print("currency", currency )
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    UserDefaultManager.set(selectedCityId, forKey: .choseCityId)
                    UserDefaultManager.set(selectedCityName, forKey: .choseCityName)
                    UserDefaultManager.set(selectedCityName, forKey: .choseCityName)
                    UserDefaultManager.set(currency, forKey: .chosenCurrency)
                    locationViewModel.userLocationName =  selectedCityName
                    isOpen = false
                }
                .disabled(selectedCityId <= 0)
                .frame(width: 150)
                .padding(.bottom, 50)
            Spacer()
        }
       
        .frame(width: .screenWidth)
        .background(Color.appBackgroundColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .clipped()
        .ignoresSafeArea()
    }
}
//
//#Preview {
//    CityView(isOpen: .constant(true))
//}
