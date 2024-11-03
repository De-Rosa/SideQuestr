import SwiftUI
import SwiftData

struct Quest: Codable {
    var isComplete: Bool
    var xp: Int
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

    func addQuest(name: String, xp: Int) {
        quests[name] = Quest(isComplete: false, xp: xp) // Create new Quest
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
    @Environment(\.modelContext) var context // Access the model context

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button("Add an Item ") {
                    addItem()
                }
                ForEach(sortedQuests, id: \.key) { questTitle, quest in
                    HStack {
                        Text("\(questTitle) (XP: \(quest.xp))") // Show XP
                            .font(.headline)
                            .foregroundColor(quest.isComplete ? .white : .black) // Use quest.isComplete
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
            .padding() // Ensure padding around the VStack
        }
        .navigationTitle("Quest Menu")
    }

    // Computed property to sort quests by completion status
    private var sortedQuests: [(key: String, value: Quest)] {
        questModel.quests.sorted { !$0.value.isComplete && $1.value.isComplete }
    }
    
    private func addItem() {
        let questName = "Quest \(questModel.quests.count + 1)" // Generate quest name
        questModel.addQuest(name: questName, xp: 5) // Call addQuest with xp
        print("Added '\(questName)' with XP: 5")
    }
}
