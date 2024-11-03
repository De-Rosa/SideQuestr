//
//  AchievementsView.swift
//  SideQuestr
//
//  Created by Samuel Singleton on 02/11/2024.
//

import SwiftUI

class AchievementModel: ObservableObject {
    @Published var achievements: [String: Bool] = [
        "Complete 1 Quest": true,
        "Complete 10 Quests": false,
        "Visit 10 pubs":true,
        "Visit 10 museums":false,
        "Visit 10 libraries":false
    ]
    
    // Function to mark an achievement as completed
    func completeAchievement(_ achievementTitle: String) {
        if achievements.keys.contains(achievementTitle) {
            achievements[achievementTitle] = true
        }
    }
}

struct AchievementEntry {
    var title: String;
    var completed: Bool;
    var xp: Int32;
    
    init(title: String, completed: Bool, xp: Int32) {
        self.title = title
        self.completed = completed
        self.xp = xp
    }
}

struct AchievementMenuView: View {
    @ObservedObject var achievement: AchievementModel
    
    // Define two columns with a flexible width
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                // Create an array of achievements as tuples
                let achievementList = achievement.achievements.map { ($0.key, $0.value) }
                
                ForEach(achievementList, id: \.0) { achievementTitle, isCompleted in
                    HStack {
                        Text("\(achievementTitle)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(isCompleted ? .black : .black)
                            .padding()
                        Spacer()
                    }
                    .padding()
                    .background(isCompleted ? Color.pink : Color.blue)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: isCompleted ? 0 : 1)
                    )
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationTitle("Achievements")
    }


    
    
    // Computed property to sort achievements by completion status
    private var sortedAchievements: [(key: String, value: Bool)] {
        achievement.achievements.sorted { !$0.value && $1.value }
    }

}
