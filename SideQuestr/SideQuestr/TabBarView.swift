//
//  TabBarView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            MapView()
                .tabItem { Label("Map", systemImage: "map") }
            QuestMenuView()

                .tabItem { Label("Quests", systemImage: "questionmark.app") }
        }
    }
}

#Preview {
    TabBarView()
}
