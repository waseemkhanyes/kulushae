//
//  ChooseCountryScreenViewModel.swift
//  Kulushae
//
//  Created by Waseem on 04/12/2024.
//

import Foundation

enum ChooseCountryScreenViewModel {
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = HomeWebService()
        private static let apiHandlerForState = MotorFilterWebServices()
        
        @Published var isLoading: Bool = false
        
        @Published var searchCountry: String = ""
        @Published var arrayCountries: [KulushaeCountry] = []
        @Published var arrayCountriesTemp: [KulushaeCountry] = []
        
        var selectedCountryWithState: CountryStateWrapper? = nil
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        var handler: ((CountryStateWrapper) -> ())? = nil
        
        init(selectedCountryWithState: CountryStateWrapper?, handler: ((CountryStateWrapper?)->())? = nil) {
            self.selectedCountryWithState = selectedCountryWithState
            self.handler = handler
            getCountryList(shouldLoading: arrayCountries.isEmpty)
        }
        
        func filterCountry(text: String) {
            
            guard !text.isEmpty else {
                arrayCountries = arrayCountriesTemp
                return
            }
            
            arrayCountries = arrayCountries.filter({($0.name ?? "").lowercased().hasPrefix(text.lowercased())})
        }
        
        func getCountryList(shouldLoading: Bool = false){
            if shouldLoading {
                isLoading = true
            }
            
            ViewModel.apiHandler.fetchCountriesList() { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                
                var countries = response
                if let selected = selectedCountryWithState {
                    countries = countries.filter({$0.id != selected.country.id})
                }
                
                self.arrayCountries = countries
                self.arrayCountriesTemp = self.arrayCountries
            }
        }
        
        //MARK: - Action -
        
        func onClickCountry(_ country: KulushaeCountry) {
            let oldId = selectedCountryWithState?.country.id ?? 0
            
            guard oldId != country.id else {
                return
            }
            
            isLoading = true
            UserDefaultManager.set(country.id, forKey: .choseCityId)
            ViewModel.apiHandlerForState.fetchStateList() { [weak self] response, error in
                guard let self = self else { return }
                isLoading = false
                let selectedCountryWithState = CountryStateWrapper(country: country, arrayState: response, selectedStateID: 0)
                self.handler?(selectedCountryWithState)
            }
        }
    }
}
