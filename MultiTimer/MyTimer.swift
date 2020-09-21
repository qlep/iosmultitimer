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
    let initialTime: Int
    var runTime: Int
    var isRunning = false
    
    // MARK: - Initialization
    init (title: String, hours: Int, minutes: Int, seconds: Int) {
        self.title = title
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        
        // total running time in seconds
        self.initialTime = self.seconds + self.minutes * 60 + self.hours * 3600
        self.runTime = self.initialTime
    }
}
