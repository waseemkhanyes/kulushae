//
//  Global.swift
//  Kulushae
//
//  Created by ios on 28/10/2023.
//

import Foundation
import UIKit

enum KulushaeActionFieldType {
    case textVal
    case price
    case dropDown
    case datePickerType
    case timePicker
    case dateNTimePicker
    case intText
    case decimal
    case textView
    case radio
    case selectionType
    case map_searchable
}

enum DataType: String, Codable {
    case textVal = "textVal"
    case price = "price"
    case file = "file"
    case textView = "textView"
}
func convertUnixTimeToFormattedDate(unixTime: TimeInterval) -> String {
    let unixTimeSeconds = unixTime / 1000
    let date = Date(timeIntervalSince1970: unixTimeSeconds)
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: date)
}
func convertToJSONString(_ dictionary: [String: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        print("Error converting dictionary to JSON: \(error.localizedDescription)")
    }
    return nil
}

func trim(_ stringContent : Any?) -> String
{
    if let content = stringContent
    {
        return String(describing:content).trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    else
    {
        return ""
    }
}

var screenEdge: UIEdgeInsets {
    var edge:UIEdgeInsets? = nil
    
    if #available(iOS 15.0, *) {
        edge = (UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first?.safeAreaInsets)
    }
    return edge ?? UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.height - screenEdge.top - screenEdge.bottom
}
