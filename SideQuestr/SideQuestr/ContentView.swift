//
//  ContentView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI


struct ContentView: View {
    @StateObject var questModel = QuestModel()
    @StateObject private var locationManager = LocationManager.shared
    @StateObject var achievementmodel = AchievementModel()

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


