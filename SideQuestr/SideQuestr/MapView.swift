//
//  MapView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI
import MapKit


struct MapView: View {

    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var message: String = ""
    @State private var userInput: String = ""

    @State var showingNotice = false
    
    var body: some View {
        ZStack {
            VStack {
                Map(position: $location)
                    .mapControls {
                        MapUserLocationButton()
                        MapPitchToggle()
                    }
            }
            
            if showingNotice {
                FloatingNotice(showingNotice: $showingNotice)
                    .transition(.scale) // Optional: add transition effect
            }

        }
    }
}

#Preview {
    MapView()
}
