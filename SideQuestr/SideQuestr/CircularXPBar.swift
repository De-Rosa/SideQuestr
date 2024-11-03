//
//  CircularXPBar.swift
//  SideQuestr
//
//  Created by Samuel Singleton on 02/11/2024.
//

import SwiftUI
import Foundation

struct CircularXPBar: View {
    
    var lineWidth: CGFloat = 20
    var color: Color = .blue
    var level: Int32
    var curr_exp: Int32
    
    @Environment(\.colorScheme) var colorScheme
    
    // Colors that change based on the color scheme
    var bgcolor: Color {
        colorScheme == .dark ? Color(UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)) : .white
    }
    
    var body: some View {
        let progress: Double = Double( curr_exp) / Double(plusnLog10(n: level))// Progress value between 0.0 and 1.0
        ZStack {
            Circle()
                .foregroundColor(bgcolor)

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

            Text("\(level)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(color)
        }
    }
}
