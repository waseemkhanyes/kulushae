//
//  SelectLocationPopupViewModel.swift
//  Kulushae
//
//  Created by Waseem  on 04/12/2024.
//

import Foundation
struct CountryStateWrapper: Codable {
    let country: KulushaeCountry
    var arrayState: [StatesModelElement]
    var selectedStateID: Int = 0
}

enum CountrySelectionForScreen {
    case ForSearch, ForAddPost
    
    var cacheKey: String {
        switch self {
        case .ForSearch:
            "selectedLocation"
        case .ForAddPost:
            "selectedLocationForAddPost"
        }
    }
}

enum SelectLocationPopupViewModel {
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = MotorFilterWebServices()
        
        @Published var selectedCountry: CountryStateWrapper? = nil

        @Published var errorString: String = ""
        @Published var isPresentLocation: Bool = false
        
        @Published var topHeader: CGFloat = .zero
        @Published var scrollContent: CGFloat = .zero
        @Published var footer: CGFloat = .zero
        
        var type: CountrySelectionForScreen = .ForSearch
        
        var strLang: String {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        }
        var countryName: String? {
            return strLang == "en" ? selectedCountry?.country.name : selectedCountry?.country.translation
        }
        var handler: (() -> ())? = nil
        
        init(type: CountrySelectionForScreen, handler: (() -> ())? = nil) {
            self.type = type
            self.handler = handler
            
            if type == .ForSearch {
                self.selectedCountry = PersistenceManager.shared.countryDataForSearch
            } else {
                self.selectedCountry = PersistenceManager.shared.countryDataForAddPost
            }
        }
        
        func scrollHeight() -> CGFloat {
            let contentSize = topHeader + scrollContent + footer
            let scrollHeight =  contentSize > screenHeight ? screenHeight - (topHeader + footer) : scrollContent
            return scrollHeight
        }
        
        func getCountryStates() -> [FlexibleViewModel] {
            guard let selectedCountryWithState = selectedCountry else { return [] }
            
            let arrayFlexibleModel = selectedCountryWithState.arrayState.map { statesItem in
                let id = statesItem.id ?? 0
                let name = strLang == "en" ? trim(statesItem.name) : trim(statesItem.translation)
                return FlexibleViewModel(id: id, name: name)
            }
            return arrayFlexibleModel
        }
        
        func validateSelection() -> Bool {
            guard selectedCountry != nil else {
                errorString = "Please select a country"
                return false
            }
            
            if type == .ForAddPost {
                guard selectedCountry?.selectedStateID ?? 0 > 0 else {
                    errorString = "Please select a state"
                    return false
                }
            }

            errorString = ""
            return true
        }
        
        //MARK: - Action -
        
        func onClickDismissDesireLocation(selectedCountryWithState: CountryStateWrapper?) {
            isPresentLocation = false
            
            guard selectedCountry?.country.id != selectedCountryWithState?.country.id else {
                return
            }
            
            
            var updatedLocation = selectedCountryWithState
            if type == .ForSearch {
                let defaultState = StatesModelElement(id: 0, name: "All", translation: "الجميع", countryID: nil, state_code: nil, latitude: nil, longitude: nil)
                updatedLocation?.arrayState.insert(defaultState, at: 0)
            }
            
            self.selectedCountry = updatedLocation
        }
        
        func onClickSelectState(stateID: Int) {
            selectedCountry?.selectedStateID = stateID
        }
        
        func onClickOk() {
            guard validateSelection(), let country = selectedCountry else { return }
            
            
            if type == .ForSearch {
                PersistenceManager.shared.countryDataForSearch = country
            } else if type == .ForAddPost {
                guard country.selectedStateID > 0 else { return }
                
                PersistenceManager.shared.countryDataForAddPost = country
            }
            
            self.handler?()
            
            do {
                let encodedData = try JSONEncoder().encode(country)
                UserDefaults.standard.set(encodedData, forKey: type.cacheKey)
                
            } catch {
                print("Error encoding selected location: \(error.localizedDescription)")
            }
        }
    }
}
