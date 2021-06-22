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
            timer!.targetDate = Date(timeIntervalSinceNow: Double(timer!.setTime))
            timeLabel.text = displayTime(of: timer!)
            titleLabel.text = timer!.title
            statusLabel.text = "Tap to start/pause"
            
            print("passed to cell \(timer!.title): \(timer!.setTime)")
        }
    }
    
    func setPause() {
        statusLabel.text = "Paused"
    }
    
    func updateTime() {
        if let timer = timer {
            let diffTimeInterval = timer.countdown()
            
            if diffTimeInterval >= 0 {
                statusLabel.text = ""
            } else {
                timer.isRunning = false
                timer.runningTime = timer.setTime
                timer.targetDate = Date(timeIntervalSinceNow: Double(timer.runningTime))
                
                statusLabel.text = "Done"
            }
            
            timeLabel.text = displayTime(of: timer)
        }
    }
    
    // return formatted time string
    func displayTime(of timer: MyTimer) -> String {
        
        let timer = timer
        
        if timer.isRunning == false {
            timer.targetDate = Date(timeIntervalSinceNow: Double(timer.setTime))
        }
        
        let diffTimeInterval = timer.countdown()
        
        let hours = diffTimeInterval / 3600
        let minutes = (diffTimeInterval / 60) % 60
        let seconds = diffTimeInterval % 60
        
        timer.runningTime = diffTimeInterval
        
        return (hours < 10 ? "0" : "") + String(hours) + ":" + (minutes < 10 ? "0" : "") + String(minutes) + ":" + (seconds < 10 ? "0" : "") + String(seconds)
    }
}
