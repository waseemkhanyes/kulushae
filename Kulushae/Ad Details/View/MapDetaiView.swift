//
//  MapDetaiView.swift
//  Kulushae
//
//  Created by ios on 22/11/2023.
//
import CoreLocation
import SwiftUI

struct MapDetailsView: View {
    @Binding var isFullscreen: Bool
    @State var coordinateString = ""
    @Binding var selectedLocation: CLLocationCoordinate2D
    @Binding  var selectedPlace: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapBoxMapView(fromVC: "details", selectedLocationCoordinate: $selectedLocation, selectedLoca: $selectedPlace)
                .onTapGesture {
                    isFullscreen = true
                }
                .clipped()
                .cornerRadius(15)
                .onAppear() {
                    if let coordinate = GeocodingService.coordinateFromString(coordinateString) {
                        // Use 'coordinate' as needed
                        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                    } else {
                        print("Invalid coordinate string format")
                    }
                }
            HStack{
                Image("fullscreen")
                    .onTapGesture {
                        isFullscreen = true
                    }
            }
            .padding(.bottom, 10)
            
        }
    }
}
