//
//  FilterDropDownViewModel.swift
//  Kulushae
//
//  Created by Waseem  on 04/01/2025.
//
import SwiftUI

class FilterDropDownViewModel: ObservableObject {
    var data: JSON
    
    @Published var arrayOptions: [JSON] = []
    @Published var scrollContent: CGFloat = .zero
    var handler: ((JSON?)->())? = nil
    
    var title: String {
        data["title"].stringValue
    }
    var strLang: String {
        UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    }
    
    init(data: JSON, _ handler: ((JSON?)->())? = nil) {
        self.data = data
        self.handler = handler
        let apiName = data["api_name"].stringValue
        if apiName.isEmpty {
            addAllOption(data: self.data["values"].arrayValue)
        } else {
            if apiName == "motor_makes" {
                getMotorMakesApi()
            } else {
                getModelsApi()
            }
        }
    }
    
    func addAllOption(data: [JSON]) {
        var values = data
        values.insert( JSON(["id": "", "name": strLang == "en" ? "All" : "الجميع"]), at: 0)
        arrayOptions = values
    }
    
    func onClickFreeArea() {
        handler?(nil)
    }
    
    func onClickOption(_ option: JSON) {
        handler?(option)
    }
    
    func getMotorMakesApi(){
        RestAPINetworkManager.shared.callEndPoint(
            url: Config.baseURL + data["api_name"].stringValue,
            method: .get,
            headers: ["X-App-Language": strLang]
        ) { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print("** wk getMotorMakesApi: \(jsonData)")
                self.addAllOption(data: jsonData.arrayValue)
            case .failure(let error):
                print("** wk error: \(error.localizedDescription)")
            }
        }
    }
    
    func getModelsApi(){
        RestAPINetworkManager.shared.callEndPoint(
            url: Config.baseURL + data["api_name"].stringValue,
            method: .post,
            parameters: ["make_id": data["motor_makes_selection"]["id"].stringValue],
            headers: ["X-App-Language": strLang]
        ) { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print("** wk getModelsApi: \(jsonData)")
                self.addAllOption(data: jsonData.arrayValue)
            case .failure(let error):
                print("** wk error: \(error.localizedDescription)")
            }
        }
    }
}
