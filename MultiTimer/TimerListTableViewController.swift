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
        startTimer()
    }
    
    @IBAction func editTimers() {
        isEditing.toggle()
        
        if isEditing {
            editButton.title = "Delete"
        } else {
            editButton.title = "Edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
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
        if !isEditing {
            // deselect row after tap
            tableView.deselectRow(at: indexPath, animated: true)
            // toggle timer state
            timers[indexPath.row].isRunning.toggle()
            startTimer()
        }
        
        if isEditing {
            timers.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
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
            if timer.isRunning {
                // get index of running timer
                if let timerIndex = timers.firstIndex(where: {$0 === timer}) {
                    // create IndexPath from index of running timer
                    let indexPath = IndexPath(row: timerIndex, section: 0)
                    // start updating cell at index of running timer
                    let cell = tableView.cellForRow(at: indexPath) as! TimerTableViewCell
                    cell.updateTime()
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
