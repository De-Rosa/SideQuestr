//
//  MapView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var isAuthorized: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        checkAuthorizationStatus()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }

    public func checkAuthorizationStatus() {
        isAuthorized = manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
    }
}

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var progress: Double = 0.5 // Sample progress value
    @State private var message: String = ""
    @State private var userInput: String = ""

    var body: some View {
        ZStack {
            Map(position: $location)
                .mapControls {
                    MapUserLocationButton()
                    MapPitchToggle()
                }
            
            if !locationManager.isAuthorized {
                LocationNotAllowed()
            }
            
            VStack {
                Spacer()
                CircularXPBar(progress: progress, color: .purple)
                    .frame(width: 100, height: 100) // Adjust size as needed
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            locationManager.checkAuthorizationStatus()
        }
    }
}

#Preview {
    MapView()
}
