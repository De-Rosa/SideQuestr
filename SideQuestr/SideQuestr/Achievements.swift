import CoreLocation
import CoreData
import UIKit
import Combine
import Foundation

public class AchievementsManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = AchievementsManager()
    private let manager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    
    override init() {
        super.init()
        manager.delegate = self
    }
}

class AchievementStore : ObservableObject {
    static let shared = AchievementStore()
    private let context = PersistenceController.shared.container.viewContext

    @Published var achievements: [AchievementEntry] = []

    init() {
        achievements = fetchAllAchievements()
     }
    
    func saveAchievement(_ achievement: AchievementStored) {
        let newAchievement = AchievementStored(context: context)
        newAchievement.title = achievement.title
        newAchievement.completed = achievement.completed
        newAchievement.xp = achievement.xp

        do {
            try context.save()
            achievements = fetchAllAchievements()
        } catch {
            print("Failed to save achievement: \(error.localizedDescription)")
        }
    }

    func fetchAllAchievements() -> [AchievementEntry] {
        let fetchRequest: NSFetchRequest<AchievementStored> = AchievementStored.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]

        do {
            let savedAchievements = try context.fetch(fetchRequest)
            return savedAchievements.compactMap { savedAchievement in
                let achieve = AchievementEntry(title: savedAchievement.title ?? "", completed: savedAchievement.completed, xp: savedAchievement.xp)
                return achieve
            }
        } catch {
            print("Failed to fetch achievements: \(error.localizedDescription)")
            return []
        }
    }
}
