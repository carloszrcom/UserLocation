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
    @State private var showLocationAlert = false
    @State private var locationManager = CLLocationManager()
    
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
            checkLocationAuthorization()
        }
        .overlay {
            LocationPermissionAlert(isPresented: $showLocationAlert)
        }
    }
    
    // MARK: - Functions
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            showLocationAlert = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Alert

struct LocationPermissionAlert: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        EmptyView()
            .alert("Ubicación necesaria", isPresented: $isPresented) {
                Button("Ir a Ajustes") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Para usar esta app necesitamos acceder a tu ubicación. Por favor, activa el permiso en los ajustes.")
            }
    }
}

#Preview {
    ContentView()
}
