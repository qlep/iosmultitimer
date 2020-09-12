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
    var ticker: Timer?
    
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
        
        if let cell = cell as? TimerTableViewCell {
            cell.timer = timer
        }
        
        return cell
    }
    
    // when rows tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        timers[indexPath.row].isRunning.toggle()
        startTimer()
        
    }
    
    // MARK: - Timer Methods
    func startTimer() {
        if ticker == nil {
            ticker = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            print("*** already running")
        }
    }
    
    // method to be called by ticker every second of countdown
    @objc func updateTimer() {
        for timer in timers {
            if timer.isRunning {
                if let timerIndex = timers.firstIndex(where: {$0 === timer}) {
                    let indexPath = IndexPath(row: timerIndex, section: 0)
                    let cell = tableView.cellForRow(at: indexPath) as! TimerTableViewCell
                    cell.updateTime()
                    print("*** updating \(timer.title)")
                }
            }
        }
        
        let runningTimers = timers.filter{$0.isRunning}
        
        if runningTimers.count == 0 {
            stopTimer()
        }
    }
    
    func stopTimer() {
        if ticker != nil {
            ticker?.invalidate()
            ticker = nil
            print("*** Ticker invalidated")
        }
    
    }
}

