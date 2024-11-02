//
//  CircularXPBar.swift
//  SideQuestr
//
//  Created by Samuel Singleton on 02/11/2024.
//

import SwiftUI

struct CircularXPBar: View {
    var progress: Double // Progress value between 0.0 and 1.0
    var lineWidth: CGFloat = 20
    var color: Color = .blue

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.4)
                .foregroundColor(color)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0), value: progress)

            Text("XP")
                .font(.largeTitle)
                .bold()
                .foregroundColor(color)
        }
    }
}
