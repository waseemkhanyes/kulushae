//
//  FormModel.swift
//  Kulushae
//
//  Created by ios on 30/10/2023.
//

import Foundation
import SwiftyJSON

// MARK: - FetchFormModel
struct FetchFormModel: Codable {
    let data: FormDataClass
    let errors: [APIError]
}

// MARK: - DataClass
struct FormDataClass: Codable {
    let fetchForm: [[FetchFormDataModel]]
}

// MARK: - FetchForm
struct FetchFormDataModel: Codable, Hashable, Identifiable  {
    
    static func == (lhs: FetchFormDataModel, rhs: FetchFormDataModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let fieldExtras: FieldExtras
    let fieldName: String
    let fieldOrder: Int
    let fieldRequestType: String
    let fieldSize: Int
    let fieldType: String
    let fieldValidation: String
    let id: String
    let steps, categoryID: Int
    var fieldValue: String?
    var fieldEditedValue: String = ""
    
    enum CodingKeys: String, CodingKey {
        case fieldExtras = "field_extras"
        case fieldName = "field_name"
        case fieldOrder = "field_order"
        case fieldRequestType = "field_request_type"
        case fieldSize = "field_size"
        case fieldType = "field_type"
        case fieldValidation = "field_validation"
        case id, steps
        case categoryID = "category_id"
        case fieldValue
    }
}
enum OptionValue: Codable {
    case intValue(Int)
    case doubleValue(Double)
    case stringValue(String)
    case boolValue(Bool)

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()

            if let intValue = try? container.decode(Int.self) {
                self = .intValue(intValue)
            } else if let doubleValue = try? container.decode(Double.self) {
                self = .doubleValue(doubleValue)
            } else if let stringValue = try? container.decode(String.self) {
                self = .stringValue(stringValue)
            } else if let boolValue = try? container.decode(Bool.self) {
                self = .boolValue(boolValue)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid value type")
            }
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Error decoding OptionValue: \(error.localizedDescription)"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .intValue(let intValue):
            try container.encode(intValue)
        case .doubleValue(let doubleValue):
            try container.encode(doubleValue)
        case .stringValue(let stringValue):
            try container.encode(stringValue)
        case .boolValue(let boolValue):
            try container.encode(boolValue)
        }
    }
}
struct Option: Codable {
    let text: String
    let value: OptionValue

    enum CodingKeys: String, CodingKey {
        case text, value
    }
}


struct FieldExtras: Codable {
    let title: String?
    let position: String?
    let alignment: String?
    let extra_title: String?
    let extra_title_icon: String?
    let extra_icon_description: String?
    let extra_icon_position: String?
    let extra_icon_alignment: String?
    let next_step: String?
    let button_action: String?
    let options: [Option]?
    let submit: String?
    let api: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        position = try container.decodeIfPresent(String.self, forKey: .position)
        alignment = try container.decodeIfPresent(String.self, forKey: .alignment)
        extra_title = try container.decodeIfPresent(String.self, forKey: .extra_title)
        extra_title_icon = try container.decodeIfPresent(String.self, forKey: .extra_title_icon)
        extra_icon_description = try container.decodeIfPresent(String.self, forKey: .extra_icon_description)
        extra_icon_position = try container.decodeIfPresent(String.self, forKey: .extra_icon_position)
        extra_icon_alignment = try container.decodeIfPresent(String.self, forKey: .extra_icon_alignment)
        next_step = try container.decodeIfPresent(String.self, forKey: .next_step)
        button_action = try container.decodeIfPresent(String.self, forKey: .button_action)
        submit = try container.decodeIfPresent(String.self, forKey: .submit)
        api = try container.decodeIfPresent(String.self, forKey: .api)

        // Handle decoding of options array
        options = try container.decodeIfPresent([Option].self, forKey: .options)
    }

    init(jsonString: String) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSON(data: dataFromString)

                title = json["title"].stringValue
                position = json["position"].stringValue
                alignment = json["alignment"].stringValue
                extra_title = json["extra_title"].stringValue
                extra_title_icon = json["extra_title_icon"].stringValue
                extra_icon_description = json["extra_icon_description"].stringValue
                extra_icon_position = json["extra_icon_position"].stringValue
                extra_icon_alignment = json["extra_icon_alignment"].stringValue
                next_step = json["next_step"].stringValue
                button_action = json["button_action"].stringValue
                submit = json["submit"].stringValue
                api = json["api"].stringValue

                options = json["options"].array?.map { optionJson in
                                let text = optionJson["text"].stringValue

                                // Handle different value types
                                let rawValue = optionJson["value"].rawValue
                                let optionValue: OptionValue

                                if let intValue = rawValue as? Int {
                                    optionValue = .intValue(intValue)
                                } else if let doubleValue = rawValue as? Double {
                                    optionValue = .doubleValue(doubleValue)
                                } else if let stringValue = rawValue as? String {
                                    optionValue = .stringValue(stringValue)
                                } else if let boolValue = rawValue as? Bool {
                                    optionValue = .boolValue(boolValue)
                                } else {
                                    // Handle other cases or throw an error as needed
                                    optionValue = .stringValue("Invalid Value")
                                }

                                return Option(text: text, value: optionValue)
                            }
            } catch {
                // Handle the error here
                print("Error decoding JSON data: \(error)")
                title = nil
                position = nil
                alignment = nil
                extra_title = nil
                extra_title_icon = nil
                extra_icon_description = nil
                extra_icon_position = nil
                extra_icon_alignment = nil
                next_step = nil
                button_action = nil
                submit = nil
                options = nil
                api = nil
            }
        } else {
            title = nil
            position = nil
            alignment = nil
            extra_title = nil
            extra_title_icon = nil
            extra_icon_description = nil
            extra_icon_position = nil
            extra_icon_alignment = nil
            next_step = nil
            button_action = nil
            submit = nil
            options = nil
            api = nil
        }
    }
}

//struct FieldExtras: Codable {
//    let title: String?
//    let position: String?
//    let alignment: String?
//    let extra_title: String?
//    let extra_title_icon: String?
//    let extra_icon_description: String?
//    let extra_icon_position: String?
//    let extra_icon_alignment: String?
//    let next_step: String?
//    let button_action: String?
//    let options: [String]?
//    let radioValue: [String]?
//    enum CodingKeys: String, CodingKey {
//        case title, position, alignment
//        case extra_title, extra_title_icon, extra_icon_description, extra_icon_position, extra_icon_alignment
//        case next_step
//        case options, button_action, radioValue
//    }
//    
//    
//    
//    init(jsonString: String) {
//        
//        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
//            do {
//                
//                let json = try JSON(data: dataFromString)
//                
//                title = json["title"].stringValue
//                position = json["position"].stringValue
//                alignment = json["alignment"].stringValue
//                extra_title = json["extra_title"].stringValue
//                extra_title_icon = json["extra_title_icon"].stringValue
//                extra_icon_description = json["extra_icon_description"].stringValue
//                extra_icon_position = json["extra_icon_position"].stringValue
//                extra_icon_alignment = json["extra_icon_alignment"].stringValue
//                next_step = json["next_step"].stringValue
//                button_action = json["button_action"].stringValue
//                options =  json["options"].arrayValue.map {$0["text"].stringValue}
//                radioValue = json["options"].arrayValue.map {$0["value"].stringValue}
//            } catch {
//                // Handle the error here
//                print("Error decoding JSON data: \(error)")
//                title = nil
//                position = nil
//                alignment = nil
//                extra_title = nil
//                extra_title_icon = nil
//                extra_icon_description = nil
//                extra_icon_position = nil
//                extra_icon_alignment = nil
//                next_step = nil
//                button_action = nil
//                options = nil
//                radioValue = nil
//            }
//        }
//        else {
//            title = nil
//            position = nil
//            alignment = nil
//            extra_title = nil
//            extra_title_icon = nil
//            extra_icon_description = nil
//            extra_icon_position = nil
//            extra_icon_alignment = nil
//            next_step = nil
//            button_action = nil
//            options = nil
//            radioValue = nil
//        }
//        
//    }
//}


