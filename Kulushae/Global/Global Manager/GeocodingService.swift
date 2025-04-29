//
//  GeocodingService.swift
//  Kulushae
//
//  Created by ios on 10/11/2023.
//

import CoreLocation

class GeocodingService {

    func getCoordinates(forPlaceName placeName: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(placeName) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            if let firstLocation = placemarks?.first?.location {
                let coordinates = firstLocation.coordinate
                completion(coordinates, nil)
            } else {
                print("No coordinates found for place: \(placeName)")
                completion(nil, nil) // Handle the case where no coordinates are found
            }
        }
    }
    
    static func coordinateFromString(_ coordinateString: String) -> CLLocationCoordinate2D? {
        if let commaIndex = coordinateString.firstIndex(of: ",") {
            let latitudeString = coordinateString[..<commaIndex]
            let longitudeString = coordinateString[coordinateString.index(after: commaIndex)...]

            if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                // Log an error or handle invalid coordinate format
                return nil
            }
        } else {
            // Log an error or handle invalid coordinate format
            return nil
        }
    }
}
