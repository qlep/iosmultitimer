//
//  TimerTableViewCell.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 12.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    var initialTime = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: MyTimer? {
        didSet {
            titleLabel.text = timer!.title
            timeLabel.text = displayTime(of: timer!)
            initialTime = timer!.runTime
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super .setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
    func updateTime() {
        if let timer = timer {
            if timer.runTime != 0 {
                timer.runTime -= 1
                
            } else {
                timer.isRunning = false
                timer.runTime = initialTime
            }
            
            timeLabel.text = displayTime(of: timer)
        }
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
