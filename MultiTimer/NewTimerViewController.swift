//
//  NewTimerViewController.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 13.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

// pickerView component values in an ordered range
struct pickerViewComponents {
    var hrs = [Int](0...23)
    var mins = [Int](0...59)
    var secs = [Int](0...59)
}

struct selectedTime {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 1
}

class NewTimerViewController: UIViewController {
    
    // MARK: - Properties
    
    
    var pickerComponents = pickerViewComponents()
    var timeSelected = selectedTime()
    var titleString = ""
    var timer: MyTimer?
    var index: Int!
    
    // MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBAction func startTimer() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.selectRow(1, inComponent: 2, animated: true)
        
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        
        startButton.isEnabled = false
        
        // Set views if editing an exisiting timer
        if let timer = timer {
            navigationBar.title = "Edit timer"
            titleTextField.text = timer.title
            startButton.isEnabled = true
            startButton.titleLabel!.text = "Done"
            
            pickerView.selectRow(timer.hours, inComponent: 0, animated: true)
            pickerView.selectRow(timer.minutes, inComponent: 1, animated: true)
            pickerView.selectRow(timer.seconds, inComponent: 2, animated: true)
            
            timeSelected.hours = timer.hours
            timeSelected.minutes = timer.minutes
            timeSelected.seconds = timer.seconds
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TimerListTableViewController
        if var editedTimer = timer {
            editedTimer = MyTimer(title: titleTextField.text!, hours: timeSelected.hours, minutes: timeSelected.minutes, seconds: timeSelected.seconds)
            
            controller.timer = editedTimer
            controller.index = index
        } else {
            let newTimer = MyTimer(title: titleString, hours: timeSelected.hours, minutes: timeSelected.minutes, seconds: timeSelected.seconds)
            
            controller.timer = newTimer            
            controller.index = -1
            print(">>>>>>> new timer title: \(newTimer.title), runtime: \(newTimer.runningTime)")
        }
    }
}

// MARK: - Class Extensions
extension NewTimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - PickerView Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return pickerComponents.hrs.count
        } else if component == 1 {
            return pickerComponents.mins.count
        } else {
            return pickerComponents.secs.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(pickerComponents.hrs[row])
        } else if component == 1 {
            return String(pickerComponents.mins[row])
        } else {
            return String(pickerComponents.secs[row])
        }
    }
    
    // UIPickerView data source
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            timeSelected.hours = pickerComponents.hrs[row]
        }else if (component == 1) {
            timeSelected.minutes = pickerComponents.mins[row]
        }else if (component == 2){
            timeSelected.seconds = pickerComponents.secs[row]
        }
    }
}

extension NewTimerViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           //Hide keyboard
           titleTextField.resignFirstResponder()
           return true
       }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text == "" {
            titleString = "neu timier"
        } else {
            titleString = titleTextField.text!
        }
        
       startButton.isEnabled = true
    }
}
