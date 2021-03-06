//
//  ViewController.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 8.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import UserNotifications

class TimerListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var timers: [MyTimer] = []
    var ticker: Timer?
    var timer: MyTimer?
    var index: Int = -1
    var badgeCount: Int = UIApplication.shared.applicationIconBadgeNumber
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private var pendingNotificationRequests: [UNNotificationRequest] = []
    
    @IBOutlet weak var newTimerButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func editTimers() {
        isEditing.toggle()
        
        if isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
    // NewTimerViewController segue unwinds here
    @IBAction func userDidStartNewTimer(_ segue: UIStoryboardSegue) {
        
        if let timer = timer {
            if index >= 0 {
                timers.remove(at: index)
                timers.insert(timer, at: index)
            } else {
                timers.append(timer)
                print("--- added \(timer.title): runtime: \(timer.runningTime)")
            }
            
            timer.isRunning = true
            
            scheduleNotification(id: index, title: timer.title, date: timer.targetDate, sound: true)
            
            tableView.reloadData()
            saveTimers()
            startTimer()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // request permission to send notification
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            [weak self] (granted, error) in
            
            guard let self = self else {return}
            guard granted else {return}
            
            self.notificationCenter.delegate = self
        })
        
        // when done tapped
        Notification.Name.doneButton.onPost { [weak self] notification in
            self!.badgeCount -= 1
            
            if self!.badgeCount < 0 {
                self!.badgeCount = 0
            }
        }
        
        // when again tapped
        Notification.Name.againButton.onPost { [weak self] notification in
            let timerInt = Int(truncating: notification.userInfo!["timerId"] as! NSNumber)
            let timer = self!.timers[timerInt]
            
            DispatchQueue.main.async {
                timer.isRunning = true
                timer.targetDate = Date(timeIntervalSinceNow: Double(timer.runningTime))
                self!.scheduleNotification(id: timerInt, title: timer.title, date: timer.targetDate, sound: true)
                self!.startTimer()
            }
        }
        
        loadTimers()
        
        for timer in timers {
            print(">>> loaded timer \(timer.title): \(timer.runningTime)")
        }
        
        checkNotificationSettings()
        refreshNotificationList()
        
    }
    
    // MARK: - Helper Methods
    func checkNotificationSettings() {
        // check if notifications allowed, act accordingly
        notificationCenter.getNotificationSettings {
            settings in
            if settings.authorizationStatus != .authorized {
                // alert to enable settings
                DispatchQueue.main.async {
                    self.enableNotificationsAlert()
                }
            }
        }
    }
    
    // alert use to enable notifications
    func enableNotificationsAlert() {
        let alert = UIAlertController(title: "Enable notifications", message: "Please enable notifications in settings to be notified when your timer is done.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // keep pending notification list fresh
    func refreshNotificationList() {
        notificationCenter.getPendingNotificationRequests (completionHandler: {
            [weak self] requests in
            
            guard let self = self else { return }
            
            self.pendingNotificationRequests = requests
        })
    }
    
    // MARK: - Scheduling notifications
    func scheduleNotification(id: Int, title: String, date: Date, sound: Bool) {
        
        let content = UNMutableNotificationContent()
        content.title = "\(title)"
        content.body = "👍"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "DoneOrNone"
        content.userInfo = ["timerId" : id]
        
        badgeCount += 1
        
        content.badge = NSNumber(value: badgeCount)
        
        // the trigger is date in future
        let triggerDate = date
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: String(id), content: content, trigger: trigger)
        
        print("*** added \(title) with badge count: \(badgeCount)")
        
        notificationCenter.add(request) {
            error in
            
            if let error = error {
                print("*** FAILED to schedule notification. \(error.localizedDescription)")
            }
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
            
            // get index of running timer
            if let timerIndex = timers.firstIndex(where: {$0 === timer}) {
                // create IndexPath from index of running timer
                let indexPath = IndexPath(row: timerIndex, section: 0)
                // start updating cell at index of running timer
                let cell = tableView.cellForRow(at: indexPath) as! TimerTableViewCell
                
                if timer.isRunning {
                    cell.updateTime()
                } else if timer.runningTime != timer.setTime {
                    // when timer paused
                    cell.setPause()
                }
            }
        }
        
        // set array of running timers, trailing closure
        let runningTimers = timers.filter{$0.isRunning}
        
        // invalidate ticker if no timers in array running
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
    
    // MARK: - TableView data source
    // only one section in table
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
            
            if timer.runningTime != timer.setTime {
                cell.setPause()
            }
        }
        
        return cell
    }
    
    // swipe cell to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        timers.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .fade)
        
        saveTimers()
    }
    
    // in order to reorder cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let timer = timers[sourceIndexPath.row]
        timers.remove(at: sourceIndexPath.row)
        timers.insert(timer, at: destinationIndexPath.row)
        
        saveTimers()
    }
    
    // MARK: - TableViewDelegate
    // when row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timer = timers[indexPath.row]
        // deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        // toggle timer state
        timer.isRunning.toggle()
        timer.targetDate = Date(timeIntervalSinceNow: Double(timer.runningTime))
        
        if timer.isRunning {
            scheduleNotification(id: indexPath.row, title: timer.title, date: timer.targetDate, sound: true)
        } else {
            // must remove notification for paused timer
            guard !pendingNotificationRequests.isEmpty else {return}
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [String(indexPath.row)])
            badgeCount -= 1
            print("*** set PAUSED with badge count: \(badgeCount)")
        }
        
        refreshNotificationList()
        saveTimers()
        startTimer()
    }
    
    // MARK: - Swipe actions
    // swiping on cell to the right action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let timer = self.timers[indexPath.row]
        // to reset timer
        let resetAction = UIContextualAction(style: .normal, title: "Reset", handler: {(ac: UIContextualAction, view: UIView, success: (Bool)-> Void) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TimerTableViewCell
            
            timer.runningTime = timer.setTime
            timer.targetDate = Date(timeIntervalSinceNow: Double(timer.setTime))
            cell.timeLabel.text = cell.displayTime(of: timer)
            
            cell.statusLabel.text = ""
            
            self.saveTimers()
            
            success(true)
        })
        
        // to edit timer
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(ac: UIContextualAction, view: UIView, success: (Bool)-> Void) in
            
            // this is how view controller is instantiated
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewTimer") as! NewTimerViewController
            let timerIndex = indexPath.row
            
            controller.timer = timer
            controller.index = timerIndex
            
            self.present(controller, animated: true)
            
            success(true)
        })

        resetAction.backgroundColor = .systemPurple
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [resetAction, editAction])
    }
}

// MARK: - Data Presistance
extension TimerListTableViewController {
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
        
        for timer in timers {
            timer.targetDate = Date(timeIntervalSinceNow: Double(timer.runningTime))
        }
    }
}

