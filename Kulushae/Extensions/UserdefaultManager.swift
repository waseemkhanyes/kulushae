//
//  UserdefaultManager.swift
//  Kulushae
//
//  Created by ios on 20/10/2023.
//

import Foundation

class UserDefaultManager {
    enum Key: String {
        case choseCityId
        case choseCityName
        case chosenCurrency
        case choseStateId
        case choseStateName
        // Add more keys as needed
    }

    static func set(_ value: Any, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    static func get<T>(_ key: Key) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
}
