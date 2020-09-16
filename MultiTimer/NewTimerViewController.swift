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
    var selectedSeconds: Int = 0
    var titleString = ""
    
    // MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startTimer() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.selectRow(1, inComponent: 1, animated: true)
        
        selectedMinutes = 1
        
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        startButton.isEnabled = false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TimerListTableViewController
        let timer = MyTimer(title: titleString, hours: selectedHours, minutes: selectedMinutes, seconds: selectedSeconds)
        controller.timers.append(timer)
        controller.saveTimers()
        timer.isRunning = true
        
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
