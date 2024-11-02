import SwiftUI
import MapKit
import CoreLocation

extension Color {
    static let noticeColor = Color(red: 0.0, green: 0.5, blue: 0.0) // Custom snackbar color
}

struct MapView: View {
    @StateObject private var questModel = QuestModel() // Shared instance of QuestModel
    @State var showingNotice = false

    var body: some View {
        NavigationView {
            ZStack { // Use ZStack to overlay views
                GeometryReader { geometry in
                    VStack(spacing: 0) { // Set spacing to 0 to minimize gaps
                        Text("SideQuestr")
                            .font(.largeTitle)
                            .padding(.top, 20) // Add top padding
                            .padding(.bottom, 10) // Add bottom padding for spacing below the text

                        Map(initialPosition: .region(region))
                            .frame(height: geometry.size.height * 0.65) // Set the height to 65% of the available space

                        // Remove or set a smaller spacer for additional space between map and buttons
                        Spacer(minLength: 2) // Set to a smaller value for less space

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

                        // Add a smaller spacer between buttons
                        Spacer(minLength: 2) // Set to a smaller value for less space

                        // Navigation link to the Quest Menu
                        NavigationLink {
                            QuestMenuView(questModel: questModel) // Pass the quest model to the QuestMenuView
                        } label: {
                            Text("Go to Quest Menu")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal) // Keep horizontal padding
                    .navigationTitle("Map View")
                }

                // Floating notice overlay in the center of the screen
                if showingNotice {
                    FloatingNotice(showingNotice: $showingNotice)
                        .transition(.scale) // Optional: add transition effect
                }
            }
        }
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 54.757663636, longitude: -1.575164366),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

struct FloatingNotice: View {
    @Binding var showingNotice: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "checkmark")
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .regular))
                .padding(EdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5))
            Text("Quest 2 Complete")
                .foregroundColor(.white)
                .font(.callout)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
        }
        .background(Color.noticeColor.opacity(0.75))
        .cornerRadius(5)
        .frame(maxWidth: 200) // Optional: set a max width for the notice
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingNotice = false
            })
        })
    }
}

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
            .padding()
        }
        .navigationTitle("Quest Menu")
    }

    // Computed property to sort quests by completion status
    private var sortedQuests: [(key: String, value: Bool)] {
        questModel.quests.sorted { !$0.value && $1.value }
    }
}

#Preview {
    MapView()
}
