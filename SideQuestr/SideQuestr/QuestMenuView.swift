import SwiftUI
import SwiftData

struct Quest: Codable {
    var isComplete: Bool
    var xp: Int
    var latitude: Double // New latitude attribute
    var longitude: Double // New longitude attribute
}



class QuestModel: ObservableObject {
    @Published var quests: [String: Quest] = [:]
    
    private let fileURL: URL = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("quests.json")
    }()

    init() {
        loadQuests() // Load quests from JSON on initialization
    }

    // Function to mark a quest as completed
    func completeQuest(_ questTitle: String) {
        if var quest = quests[questTitle] {
            quest.isComplete = true // Update isComplete
            quests[questTitle] = quest // Reassign to the dictionary
            saveQuests() // Save updated quests to JSON
        }
    }

    func addQuest(name: String, xp: Int, latitude: Double, longitude: Double) {
        quests[name] = Quest(isComplete: false, xp: xp, latitude: latitude, longitude: longitude) // Create new Quest
        saveQuests() // Save the quests to JSON
    }

    // Save the quests dictionary to a JSON file
    private func saveQuests() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(quests)
            try jsonData.write(to: fileURL)
            print("Successfully saved quests to \(fileURL.path)")
        } catch {
            print("Failed to save quests: \(error.localizedDescription)")
        }
    }

    // Load the quests dictionary from a JSON file
    private func loadQuests() {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileURL)
            quests = try jsonDecoder.decode([String: Quest].self, from: jsonData)
            print("Successfully loaded quests from \(fileURL.path)")
        } catch {
            print("Failed to load quests: \(error.localizedDescription)")
        }
    }
}

struct QuestMenuView: View {
    @ObservedObject var questModel: QuestModel
    @State private var questIndex: Int

    init(questModel: QuestModel) {
        self.questModel = questModel
        _questIndex = State(initialValue: questModel.quests.count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button("Add an Item") {
                    addItem()
                }
                ForEach(sortedQuests, id: \.key) { questTitle, quest in
                    HStack {
                        Text("\(questTitle) (XP: \(quest.xp))")
                            .font(.headline)
                            .foregroundColor(quest.isComplete ? .white : .black)
                            .padding()
                        Spacer()
                        
                        Image(systemName: quest.isComplete ? "checkmark.square" : "square")
                            .foregroundColor(quest.isComplete ? .black : .gray)
                    }
                    .padding()
                    .background(quest.isComplete ? Color.green.opacity(0.6) : Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: quest.isComplete ? 0 : 1)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Quest Menu")
    }

    private func addItem() {
        let newQuests: [(String, Int, Double, Double)] = [
            ("Visit the cathedral", 5, 54.773726, -1.576696), // Example coordinates for San Francisco
            ("Visit the botanic Gardens", 5, 54.761787, -54.761787),
            ("Go to durhack", 5, 54.767253, -1.576088),
            ("Quest 4", 5, 37.7749, -122.4194),
            ("Quest 5", 5, 37.7749, -122.4194),
            ("Quest 6", 5, 37.7749, -122.4194),
            ("Quest 7", 5, 37.7749, -122.4194),
            ("Quest 8", 5, 37.7749, -122.4194),
            ("Quest 9", 5, 37.7749, -122.4194),
            ("Quest 10", 5, 37.7749, -122.4194)
        ]

        guard questIndex < newQuests.count else {
            print("No more new quests to add.")
            return
        }

        let quest = newQuests[questIndex]
        questModel.addQuest(name: quest.0, xp: quest.1, latitude: quest.2, longitude: quest.3)
        questIndex += 1
        
        print("Added new quest: \(quest.0) with XP: \(quest.1) at (\(quest.2), \(quest.3))")
    }

    private var sortedQuests: [(key: String, value: Quest)] {
        questModel.quests.sorted { !$0.value.isComplete && $1.value.isComplete }
    }
}
