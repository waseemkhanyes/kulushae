//
//  LocationViewModel.swift
//  Easy Buy
//
//  Created by ios on 03/10/2023.
//

import CoreLocation
import SwiftUI

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
   
    private var locationManager = CLLocationManager()
    @Published var userLocationName: String?
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocation() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            userLocationName = "Location access denied"
        @unknown default:
            userLocationName = "Unknown location authorization status"
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                } else if let city = placemarks?.first?.locality, let country = placemarks?.first?.country {
                    let abbreviatedCountry = self?.abbreviateCountryName(country) ?? country
                    self?.userLocationName = "\(city), \(abbreviatedCountry)"
                }
                manager.stopUpdatingLocation()
            }
        }
    }
    
    func abbreviateCountryName(_ country: String) -> String {
        let countryAbbreviations = [
            "United Arab Emirates": "UAE",
            " United States": "US"
            // Add more country mappings as needed
        ]
        
        return countryAbbreviations[country] ?? country
    }
}
