//
//  MotorCategoryFilterViewModel.swift
//  Kulushae
//
//  Created by Waseem  on 02/01/2025.
//

import SwiftUI

class MotorCategoryFilterViewModel: ObservableObject {
    
    var arrayOriginalFilterOptions: [JSON] = []
    
    @Published var arrayFilterOptions: [JSON] = []
    @Published var isLoading: Bool = false
    @Published var presentDrowDown: Bool = false
    
    var dicSelectedDropwDown = JSON([:])
    let apiHandler = HomeWebService()
    
    var strLang: String {
        UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    }
    
    var handler: (([JSON]?)->())? = nil
    
    init(arrayFilters: [JSON] = [], handler: (([JSON]?)->())? = nil) {
        self.handler = handler
        if arrayFilters.isEmpty {
            getMotorQuickLinks()
        } else {
            self.arrayOriginalFilterOptions = arrayFilters.map({ item in
                var item = item
                item["selection"] = ""
                return item
            })
            
            self.arrayFilterOptions = arrayFilters
        }
        
    }
    
    func onClickCross() {
        handler?(nil)
    }
    
    func onClickReset() {
        arrayFilterOptions = arrayOriginalFilterOptions
    }
    
    func onClickApply() {
        handler?(arrayFilterOptions)
//        var data: [String: String] = [:]
//        
//        arrayFilterOptions.forEach({ item in
//            let type = FilterOptonType(rawValue: item["type"].stringValue)
//            let key = item["field_name"].stringValue
//            if let type = type {
//                switch type {
//                case .DropDown:
//                    data[key] = item["selection"]["id"].stringValue
//                case .Slider:
//                    if item["multiple"].boolValue {
//                        data[key] = item["selection"].arrayValue.map({$0["value"].stringValue}).joined(separator: ",")
//                    } else {
//                        data[key] = item["selection"]["value"].stringValue
//                    }
//                case .CheckBox:
//                    data[key] = item["selection"].stringValue
//                case .Range:
//                    data["start_\(key)"] = item["selection"]["min"].stringValue
//                    data["end_\(key)"] = item["selection"]["max"].stringValue
//                }
//            }
//            
//        })
    }
    
    func getMotorQuickLinks(shouldLoading: Bool = false){
        if shouldLoading {
            isLoading = true
        }
        
        apiHandler.fetchMotorFilters() { [weak self] response, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                
            } else {
                arrayOriginalFilterOptions = response.arrayValue
                arrayFilterOptions = arrayOriginalFilterOptions.map({ item in
                    var item = item
                    if item["type"].stringValue == "dropdown" {
                        item["selection"] = JSON(["id": "", "name": self.strLang == "en" ? "All" : "الجميع"])
                    }
                    return item
                })
            }
        }
    }
}
