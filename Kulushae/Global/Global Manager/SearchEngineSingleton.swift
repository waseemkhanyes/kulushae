//
//  SearchEngineSingleton.swift
//  Kulushae
//
//  Created by ios on 10/11/2023.
//
import MapboxSearch

public class SearchEngineSingleton {
    static let shared = SearchEngine(accessToken: "pk.eyJ1IjoiY2FzaGdhdGUiLCJhIjoiY2x4dXF1MXhxMDA3NjJyc2FseGF6NGF1MSJ9.9xTPqqB1v725uBUnu9DaQg")
    
    private lazy var searchDelegate: SearchDelegate = {
        let delegate = SearchDelegate()
        SearchEngineSingleton.shared.delegate = delegate
        return delegate
    }()
    
    init() {
        // Ensure the delegate is set before any search operation
        let _ = searchDelegate
    }
}
