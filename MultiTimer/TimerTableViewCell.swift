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
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: MyTimer? {
        didSet {
            titleLabel.text = timer?.title
            timeLabel.text = timer?.showTime()
        }
    }
    
    func updateTime() {
        if let timer = timer {
            timer.runTime -= 1
            timeLabel.text = timer.showTime()
        }
    }

}
