//
//  ContentView.swift
//  UserLocation
//
//  Created by CarlosZR on 20/11/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        Map(position: $location) {
            // Keep showing user location.
            UserAnnotation()
        }
        .mapControls({
            MapUserLocationButton()
            MapPitchToggle()
        })
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
