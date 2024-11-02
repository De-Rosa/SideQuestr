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
    
    var body: some View {
        ZStack {
            Map(initialPosition: .region(region))
                .onAppear() {
                    CLLocationManager().requestAlwaysAuthorization()
                }
            
            if (CLLocationManager().authorizationStatus != .authorizedAlways) {
                LocationNotAllowed()
            }
        }
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 54.757663636, longitude: -1.575164366),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

#Preview {
    MapView()
}
