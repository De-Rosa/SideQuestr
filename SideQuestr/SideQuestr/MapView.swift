//
//  MapView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isAuthorised =  CLLocationManager().authorizationStatus != .authorizedAlways
    var body: some View {
        ZStack {
            Map(position: $location)
                .mapControls {
                    MapUserLocationButton()
                    MapPitchToggle()
                }
                .onAppear() {
                    CLLocationManager().requestAlwaysAuthorization()
                }
            
            if (isAuthorised) {
                LocationNotAllowed()
            }
        }
    }
}

#Preview {
    MapView()
}
