//
//  NewTimerViewController.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 13.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

class NewTimerViewController: UIViewController {
    
    // MARK: - Properties
    // pickerView component values in an ordered range
    var hrs = [Int](0...23)
    var mins = [Int](0...59)
    var secs = [Int](0...59)
    
    var selectedHours: Int = 0
    var selectedMinutes: Int = 0
    var selectedSeconds: Int = 1
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
            selectedHours = timer.hours
            selectedMinutes = timer.minutes
            selectedSeconds = timer.seconds
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TimerListTableViewController
        if var editedTimer = timer {
            editedTimer = MyTimer(title: titleTextField.text!, hours: selectedHours, minutes: selectedMinutes, seconds: selectedSeconds)
            controller.timer = editedTimer
            controller.index = index
            
        } else {
            let newTimer = MyTimer(title: titleString, hours: selectedHours, minutes: selectedMinutes, seconds: selectedSeconds)
            
            controller.timer = newTimer            
            controller.index = -1
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
            return hrs.count
        } else if component == 1 {
            return mins.count
        } else {
            return secs.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(hrs[row])
        } else if component == 1 {
            return String(mins[row])
        } else {
            return String(secs[row])
        }
    }
    
    // UIPickerView data source
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            selectedHours = hrs[row]
        }else if (component == 1) {
            selectedMinutes = mins[row]
        }else if (component == 2){
            selectedSeconds = secs[row]
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
