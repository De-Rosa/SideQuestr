import SwiftUI
import MapKit
import CoreLocation


struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var message: String = ""
    @State private var userInput: String = ""
    @State private var level: Int32 = 15
    @State private var exp: Int32 = 15
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
                            exp += 5
                            (level, exp) = levelUp(lvl: level, exp: exp)
                            questModel.completeQuest("Quest \(questModel.quests.count)") // Complete top Quest
                            self.showingNotice = true
                        }, label: {
                            Text("Complete Quest")
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        })
                        
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
            VStack {
                Spacer()
                CircularXPBar(level: level, curr_exp: exp)
                    .frame(width: 100, height: 100) // Adjust size as needed
                    .position(x:80, y: 45)
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
