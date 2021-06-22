//
//  Timer.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 8.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

class MyTimer: Codable {
    // MARK: - Properties
    var title: String
    var seconds: Int
    var minutes: Int
    var hours: Int
    let setTime: Int
    var runningTime: Int
    var targetDate = Date()
    
    var isRunning: Bool {
        willSet {
            self.targetDate = Date(timeIntervalSinceNow: Double(self.setTime))
        }
    }
    
    // MARK: - Initialization
    init (title: String, hours: Int, minutes: Int, seconds: Int) {
        self.title = title
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        
        // total running time in seconds
        self.setTime = self.seconds + self.minutes * 60 + self.hours * 3600
        self.runningTime = setTime
        self.isRunning = false
    }
    
    func countdown() -> Int {
        let now = Date()
        
//        self.runningTime = Int(now.timeIntervalSince(self.targetDate))
        
        self.runningTime = Int(self.targetDate.timeIntervalSinceReferenceDate - now.timeIntervalSinceReferenceDate)
        
        print(self.runningTime)
        
        return self.runningTime
    }
}
