//
//  Extension_Array.swift
//  Kulushae
//
//  Created by ios on 20/10/2023.
//

import Foundation
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
