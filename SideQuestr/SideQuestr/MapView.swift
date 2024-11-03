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
    @State private var level: Int32 = 15
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
            VStack {
                Spacer()
                CircularXPBar(level: level, curr_exp: 25)
                    .frame(width: 100, height: 100) // Adjust size as needed
                    .position(x:80, y: 45)
                        }

        }
    }
}

#Preview {
    MapView()
}
