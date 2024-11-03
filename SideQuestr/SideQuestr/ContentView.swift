//
//  ContentView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI
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

struct ContentView: View {
    @StateObject var questModel = QuestModel() // Shared instance of QuestModel
    @StateObject var achievementmodel = AchievementModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            TabView {
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                QuestMenuView(questModel: questModel)
                    .tabItem {
                        Label("Quests", systemImage: "questionmark.app")
                    }
                AchievementMenuView(achievement: achievementmodel)
                    .tabItem {
                        Label("Achievements", systemImage: "trophy")
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
    ContentView()
}


