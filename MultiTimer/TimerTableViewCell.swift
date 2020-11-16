//
//  TimerTableViewCell.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 12.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: MyTimer? {
        didSet {
            titleLabel.text = timer!.title
            timeLabel.text = displayTime(of: timer!)
            statusLabel.text = "Tap to start/pause"
        }
    }
    
    func updateTime() {
        let now = Date()
        if let timer = timer {
            let diffTimeInterval = Int(timer.targetDate.timeIntervalSinceReferenceDate - now.timeIntervalSinceReferenceDate)
            if diffTimeInterval >= 0 {
                statusLabel.text = ""
            } else {
                timer.isRunning = false
                timer.runTime = timer.initialTime
                timer.targetDate = Date(timeIntervalSinceNow: Double(timer.runTime ))
                
                statusLabel.text = "Done"
            }
            
            timeLabel.text = displayTime(of: timer)
        }
    }
    
    func setPause() {
        statusLabel.text = "Paused"
    }
    
    // return formatted time string
    func displayTime(of timer: MyTimer) -> String {
        let timer = timer
        
        let target = timer.targetDate + 1.0
        let now = Date()
        let diffTimeInterval = Int(target.timeIntervalSinceReferenceDate - now.timeIntervalSinceReferenceDate)
        
        
        let hours = diffTimeInterval / 3600
        let minutes = (diffTimeInterval / 60) % 60
        let seconds = diffTimeInterval % 60
        
        timer.runTime = diffTimeInterval
        
        return (hours < 10 ? "0" : "") + String(hours) + ":" + (minutes < 10 ? "0" : "") + String(minutes) + ":" + (seconds < 10 ? "0" : "") + String(seconds)
    }
}
