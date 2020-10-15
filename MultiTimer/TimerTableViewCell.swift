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
        if let timer = timer {
            if timer.runTime != 0 {
                timer.runTime -= 1
                statusLabel.text = ""
            } else {
                timer.isRunning = false
                timer.runTime = timer.initialTime
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
        let hours = timer.runTime / 3600
        let minutes = (timer.runTime / 60) % 60
        let seconds = timer.runTime % 60
        
        return (hours < 10 ? "0" : "") + String(hours) + ":" + (minutes < 10 ? "0" : "") + String(minutes) + ":" + (seconds < 10 ? "0" : "") + String(seconds)
    }
}
