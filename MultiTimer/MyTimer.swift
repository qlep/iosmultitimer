//
//  Timer.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 8.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

class MyTimer {
    // MARK: - Properties
    var title = "new timer"
    var seconds: Int
    var minutes: Int
    var runTime: Int
    var isRunning = false
    
    // MARK: - Initialization
    init (title: String, minutes: Int, seconds: Int) {
        self.title = title
        self.minutes = minutes
        self.seconds = seconds
        
        self.runTime = self.seconds + self.minutes * 60
    }
}
