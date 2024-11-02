import SwiftUI

class QuestModel: ObservableObject {
    @Published var quests: [String: Bool] = [
        "Quest 1": true,
        "Quest 2": false,
        "Quest 3": false,
        "Quest 4": false,
        "Quest 5": true,
        "Quest 6": false,
        "Quest 7": false,
        "Quest 8": true,
        "Quest 9": false,
        "Quest 10": false
    ]
    
    // Function to mark a quest as completed
    func completeQuest(_ questTitle: String) {
        if quests.keys.contains(questTitle) {
            quests[questTitle] = true
        }
    }
}

struct QuestMenuView: View {
    @ObservedObject var questModel: QuestModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedQuests, id: \.key) { questTitle, isCompleted in
                    HStack {
                        Text(questTitle)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()

                        Image(systemName: isCompleted ? "checkmark.square" : "square")
                            .foregroundColor(isCompleted ? .black : .gray)
                    }
                    .padding()
                    .background(isCompleted ? Color.green.opacity(0.6) : Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: isCompleted ? 0 : 1)
                    )
                }
            }
            .padding() // Ensure padding around the VStack
        }
        .navigationTitle("Quest Menu")
    }

    // Computed property to sort quests by completion status
    private var sortedQuests: [(key: String, value: Bool)] {
        questModel.quests.sorted { !$0.value && $1.value }
    }
}

