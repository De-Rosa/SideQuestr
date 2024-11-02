import SwiftUI
struct QuestMenuView: View {
    @State private var quests: [Quest] = [
        Quest(title: "Quest 1", isCompleted: false),
        Quest(title: "Quest 2", isCompleted: false),
        Quest(title: "Quest 3", isCompleted: false)
    ]
    
    var body: some View {
        VStack(spacing: 16) { // Spacing between each quest box
            ForEach(quests.indices, id: \.self) { index in
                HStack {
                    Text(quests[index].title)
                        .font(.headline)
                        .padding() // Add padding around the text
                    Spacer() // Pushes the checkbox to the right
                    Toggle(isOn: $quests[index].isCompleted) {
                        Text("") // Empty label to create checkbox effect
                    }
                    .toggleStyle(CheckBoxToggleStyle()) // U    se a custom toggle style
                }
                .padding()
                .background(Color.gray.opacity(0.2)) // Light gray background for the box
                .cornerRadius(10) // Rounded corners
            }
        }
        .padding()
        .navigationTitle("Quest Menu") // Set the title for the destination view
    }
}

// Data model for a Quest
struct Quest {
    var title: String
    var isCompleted: Bool
}

// Custom Toggle Style to make it look like a checkbox
struct CheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .gray)
            }
        }
    }
}

