//
//  MapView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isAuthorised =  CLLocationManager().authorizationStatus == .authorizedAlways
  
    @State private var message: String = ""
    @State private var userInput: String = ""

    var body: some View {
        ZStack {
          NavigationView { // Ensure the entire view is in a NavigationView
              VStack {
                  Map(initialPosition: .region(region))
                  .mapControls {
                      MapUserLocationButton()
                      MapPitchToggle()
                  }
                  .onAppear() {
                      CLLocationManager().requestAlwaysAuthorization()
                  }
                
                  if (!isAuthorised) {
                      LocationNotAllowed()
                  }
                
                  NavigationLink(destination: QuestMenuView()) {
                      // Create a round rectangular blue button
                      Text("Quest Menu") // Text for the button
                          .font(.headline)
                          .frame(maxWidth: .infinity) // Makes the button expand to the available width
                          .padding()
                          .background(Color.blue) // Set the background color to blue
                          .foregroundColor(.white) // Text color
                          .cornerRadius(10) // Rounded corners
                          .padding(.horizontal) // Add some horizontal padding
                  }
                  .padding(.top) // Add some top padding to the NavigationLink

                  Text("SideQuestr")

                  if !message.isEmpty {
                      Text(message)
                          .font(.headline)
                          .padding()
                  }
              }
              .padding()
              .navigationTitle("Map View") // Optional: set a title for the NavigationView
          }
       }
    }

    func quest(title: String, tags: String) -> some View {
        Button {
        } label: {
            Text(title)
                .frame(maxWidth: .infinity) // Make the button expand to the available width
                .padding()
                .background(Color.blue) // Optional: Background color for visibility
                .foregroundColor(.white) // Optional: Text color
                .cornerRadius(8) // Optional: Rounded corners
        }
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 54.757663636, longitude: -1.575164366),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

struct QuestMenuView: View {
    @State private var quests: [Quest] = [
        Quest(title: "Quest 1", isCompleted: false),
        Quest(title: "Quest 2", isCompleted: false),
        Quest(title: "Quest 3", isCompleted: false)
    ]
    
    Text("")
    
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

#Preview {
    MapView()
}
