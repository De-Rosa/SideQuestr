//
//  ContentView.swift
//  SideQuestr
//
//  Created by Luca De Rosa on 02/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var message: String = ""
    @State private var userInput: String = ""

    var body: some View {
        NavigationView {
            NavigationLink {
                    // destination view to navigation to
                    ContentView()
                } label: {
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        Text("Hello, world!")
                    }
                    .padding()
                }
        }
    }
}

#Preview {
    ContentView()
}


