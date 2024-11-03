//
//  LevelMaths.swift
//  SideQuestr
//
//  Created by Tymek Niewodniczanski on 03/11/2024.
//

import Foundation

func plusnLog10(n: Int32) -> Int32 {
    guard n > 0 else {
        fatalError("n must be greater than 0")
    }
    return 10 + Int32(Double(n) * log10(Double(n)))
}

import Foundation

func levelUp(lvl: Int32, exp: Int32) -> (lvl: Int32, exp: Int32) {
    // Calculate n * log10(n) as an integer
    let threshold = plusnLog10(n: lvl)
    
    // Check if exp is enough to level up
    if exp >= threshold {
        // Increment level and subtract threshold from exp
        return (lvl + 1, exp - threshold)
    }
    
    // No level up, return current level and exp
    return (lvl, exp)
}
