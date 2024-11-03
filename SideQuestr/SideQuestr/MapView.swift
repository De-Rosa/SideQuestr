import SwiftUI
import MapKit
import CoreLocation


struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var message: String = ""
    @State private var userInput: String = ""

    @StateObject var questModel = QuestModel() // Initialize questModel here
    @State var showingNotice = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Map(position: $location)
                        .mapControls {
                            MapUserLocationButton()
                            MapPitchToggle()
                        }
                    
                    HStack {
                        Button(action: {
                            questModel.completeQuest("Quest \(questModel.quests.count)") // Complete top Quest
                            self.showingNotice = true
                        }, label: {
                            Text("Complete Quest")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        })
                        
                        NavigationLink {
                            QuestMenuView(questModel: questModel) // Pass the quest model to the QuestMenuView
                        } label: {
                            Text("Go to Quest Menu")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        if showingNotice {
                            FloatingNotice(showingNotice: $showingNotice)
                                .transition(.scale) // Optional: add transition effect
                        }
                    }
                    
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
    MapView()
}
