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
//            UserAnnotation()
            
            // Opción 1: Usando un símbolo del sistema
            UserAnnotation(anchor: .bottom) {
                Image(systemName: "location.north.fill")
                    .foregroundStyle(.blue)
                    .background(
                        Circle()
                            .fill(.white)
                            .frame(width: 26, height: 26)
                    )
            }
            
            // Opción 2: Vista personalizada con rotación
//            UserAnnotation {
//                CustomArrowView()
//            }
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

// MARK: - Arrow view

struct CustomArrowView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 40, height: 40)
            
            Image(systemName: "arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.blue)
                .background(
                    Circle()
                        .fill(.white)
                        .frame(width: 30, height: 30)
                )
        }
    }
}

#Preview {
    ContentView()
}
