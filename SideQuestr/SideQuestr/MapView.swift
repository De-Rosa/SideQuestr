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
    @State private var message: String = ""
    @State private var userInput: String = ""

    @StateObject var questModel = QuestModel() // Shared instance of QuestModel
    @State var showingNotice = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Map(position: $location)
                        .mapControls {
                            MapUserLocationButton()
                            MapPitchToggle()
                        }
                    
                    HStack {
                        Button(action: {
                            questModel.completeQuest("Quest 2") // Complete Quest 2
                            self.showingNotice = true
                        }, label: {
                            Text("Complete Quest 2")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        })
                        
                        NavigationLink {
                            QuestMenuView(questModel: questModel) // Pass the quest model to the QuestMenuView
                        } label: {
                            Text("Go to Quest Menu")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        if showingNotice {
                            FloatingNotice(showingNotice: $showingNotice)
                                .transition(.scale) // Optional: add transition effect
                        }
                    }
                    
                }
            }
            
            if !locationManager.isAuthorized {
                LocationNotAllowed()
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
