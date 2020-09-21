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
    
    @IBOutlet weak var newTimerButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // when user taps start button in NewTimerViewController
    @IBAction func userDidStartNewTimer(_ segue: UIStoryboardSegue) {
        tableView.reloadData()
        saveTimers()
        startTimer()
    }
    
    @IBAction func editTimers() {
        isEditing.toggle()
        
        if isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTimers()
    }
    
    // MARK: - Data Presistance
    // encode and save Codable objs
    // constructing filepath to apps doc dir
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    // construct and return path to file
    func dataFilePath() -> URL {
        documentDirectory().appendingPathComponent("MultiTimer.plist")
    }
    
    // data saving meth
    func saveTimers() {
        let encoder = PropertyListEncoder()
        
        do {
            // encode array into binary
            let data = try encoder.encode(timers)
            // write binary into plist file
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            // in case of errors
            print("Error encoding timers array: \(error.localizedDescription)")
        }
    }
    
    func loadTimers() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                timers = try decoder.decode([MyTimer].self, from: data)
            } catch {
                print("Error decoding timers from data: \(error.localizedDescription)")
            }
        }
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
    
    // swipe cell delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        timers.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveTimers()
    }
    
    // MARK: - TableViewDelegate
    // when rows tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        // toggle timer state
        timers[indexPath.row].isRunning.toggle()
        saveTimers()
        startTimer()
    }
    
    // swiping on cell to the right action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let timer = self.timers[indexPath.row]
        
        // to reset timer
        let resetAction = UIContextualAction(style: .normal, title: "Reset", handler: {(ac: UIContextualAction, view: UIView, success: (Bool)-> Void) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TimerTableViewCell
            
            timer.runTime = timer.initialTime
            cell.timeLabel.text = cell.displayTime(of: timer)
            
            success(true)
        })
        
        // to edit timer
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(ac: UIContextualAction, view: UIView, success: (Bool)-> Void) in
            
            // this is how view controller is instantiated
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewTimer") as! NewTimerViewController
            
            controller.timer = timer
            
            self.present(controller, animated: true)
            
            success(true)
        })

        resetAction.backgroundColor = .systemPurple
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [resetAction, editAction])
    }
    
    // MARK: - Timer Methods
    func startTimer() {
        if ticker == nil {
            ticker = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimers), userInfo: nil, repeats: true)
        }
    }
    
    // method to be called by ticker every second of countdown
    @objc func updateTimers() {
        for timer in timers {
            // get index of running timer
            if let timerIndex = timers.firstIndex(where: {$0 === timer}) {
                // create IndexPath from index of running timer
                let indexPath = IndexPath(row: timerIndex, section: 0)
                // start updating cell at index of running timer
                let cell = tableView.cellForRow(at: indexPath) as! TimerTableViewCell
                
                if timer.isRunning {
                    cell.updateTime()
                } else if timer.runTime != timer.initialTime {
                    // when timer paused
                    cell.setPause()
                }
            }
        }
        
        // array of running timers, trailing closure
        let runningTimers = timers.filter{$0.isRunning}
        // invalidate ticker if no timers running
        if runningTimers.count == 0 {
            stopTimer()
        }
    }
    
    func stopTimer() {
        // destroy Timer object
        if ticker != nil {
            ticker?.invalidate()
            ticker = nil
        }
    }
}
