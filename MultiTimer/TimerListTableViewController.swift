//
//  ViewController.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 8.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
class TimerListTableViewController: UITableViewController {
    // MARK: - Properties
    var timers: [MyTimer] = []
    var ticker = Timer()
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load fake timer array on app start
        loadTimerArray()
    }
    
    // fake timer data array
    func loadTimerArray() {
        let timer1 = MyTimer(title: "Cucumbers", minutes: 30, seconds: 15)
        let timer2 = MyTimer(title: "Eggs", minutes: 8, seconds: 0)
        let timer3 = MyTimer(title: "Spagetti", minutes: 3, seconds: 0)
        timers += [timer1, timer2, timer3]
    }
    
    // MARK: - TableView data source
    // there will always be one section in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of row equals number of timers in timers array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    // cell/row set up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath)
        
        let timer = timers[indexPath.row]
        
        cell.textLabel?.text = timer.title
        cell.detailTextLabel?.text = (timer.minutes < 10 ? "0" : "") + String(timer.minutes) + ":" + (timer.seconds < 10 ? "0" : "") + String(timer.seconds)
        
        return cell
    }
    
    // when rows tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        // selected timer from timers array
        let timer = timers[indexPath.row]
        
        // check if timer is already running
        if timer.isRunning {
            ticker.invalidate()
            timer.isRunning = false
            print("\(timer.title) is running: \(timer.isRunning)")
        } else {
            // in case timer is not running
            let context = ["timerNumber": indexPath.row]
            timer.isRunning = true
            print("\(timer.title) is running: \(timer.isRunning)")
            ticker = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: context, repeats: true)
        }
    }
    
    // MARK: - Timer Methods
    // method to be called by ticker every second of countdown
    @objc func countDown(countDownTimer: Timer) {
        var mins = 0
        var secs = 0
        
        // context dictionary passed in Timer userInfo
        guard let context = countDownTimer.userInfo as? [String:Int] else { return }
        if let selectedRow = context["timerNumber"] {
            let timer = timers[selectedRow]
            mins = timer.runTime / 60
            secs = timer.runTime - mins * 60
            
            let cell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0 ))
            
            cell?.detailTextLabel?.text = (mins < 10 ? "0" : "") + String(mins) + ":" + (secs < 10 ? "0" : "") + String(secs)
            
            timer.runTime -= 1
            print("\(timer.runTime)")
            
            
            if timer.runTime == 0 {
                stopTimer(countDownTimer)
                timer.isRunning = false
            }
        }
    }
    
    func stopTimer(_ countDownTimer: Timer) {
        countDownTimer.invalidate()
    }
}

