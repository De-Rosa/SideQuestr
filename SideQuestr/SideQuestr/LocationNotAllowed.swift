//
//  LocationNotAllowed.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI

struct LocationNotAllowed: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.3)
            VStack {
                Image("cross")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    
                Text("This app requires location services to work.")
                    .font(.title2)
                    .fontWeight(.bold)
                    
                    .multilineTextAlignment(.center)
                Text("Please enable them in your device settings.")
                    .font(.title3)
                    .padding(5)
                Button {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("Enable Location Services")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .padding()
                    }
                }
                .accessibilityAddTraits([.isButton])
                .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(colorScheme == .dark ? .black : .white)
            .shadow(color: .gray.opacity(0.1), radius: 10.0, x: 0.0, y: 10.0)
            .clipShape(RoundedRectangle(cornerRadius: 40.0))
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LocationNotAllowed()
}
