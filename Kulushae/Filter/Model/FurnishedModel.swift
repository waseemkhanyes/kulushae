//
//  FurnishedModel.swift
//  Kulushae
//
//  Created by ios on 13/02/2024.
//

import Foundation

enum FurnishedModel {
    case all
    case unfurnished
    case fullyFurnished
    
    var stringValue: String {
            switch self {
            case .all:
                return "all"
            case .unfurnished:
                return "unfurnished"
            case .fullyFurnished:
                return "fullyfurnished"
            }
        }
}
