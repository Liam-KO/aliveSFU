//
//  SubpageViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-14.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import HealthKit

class SubpageViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateFields() -> Bool {
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getSubpages() -> [SubpageViewController] {
        // Initialized arr with an empty view controller to make it 1-indexed
        var arr = [SubpageViewController()]
        
        let subpage1 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "1") as! Subpage1ViewController
        let subpage2 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "2") as! Subpage2ViewController
        let subpage3 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "3") as! Subpage3ViewController
        let subpage4 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "4") as! Subpage4ViewController
        
        arr.append(subpage1)
        arr.append(subpage2)
        arr.append(subpage3)
        arr.append(subpage4)
        
        return arr
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

/*
    Subpage 1 - My Profile
 */

class Subpage1ViewController: SubpageViewController {
    
    @IBOutlet weak var userFirstName: UITextField!
    
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userGender: UISegmentedControl!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var errorAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPhoneNumber.keyboardType = .phonePad
        userEmail.keyboardType = .emailAddress
    }
    
    //Validate if all fields are filled in properly
    //Post condition: return false if any of the fields aren't filled properly, return true if they're all filled properly
    override func validateFields() -> Bool {
        errorAlertLabel.isHidden = true
        //I have no idea how to check if the segment index is selected at all or not
        //Using this spaghetti check to see if the user has selected a gender
        if (userGender.selectedSegmentIndex != 0 && userGender.selectedSegmentIndex != 1)
        {
            errorAlertLabel.text = "Gender not selected!"
            errorAlertLabel.isHidden = false
            return false
        }
        //Outline in red the textfields that are missing
        let textViews : [UITextField] = [userFirstName, userLastName, userEmail]
        for textField in textViews
        {
            if (textField.text?.isEmpty)!
            {
                let myColor : UIColor = UIColor.red
                textField.layer.borderColor = myColor.cgColor
                textField.layer.borderWidth = 1
                errorAlertLabel.text = "Fields are missing!"
                errorAlertLabel.isHidden = false
                
            }
            else
            {
                textField.layer.borderWidth = 0
            }
        }
        if (errorAlertLabel.isHidden) {
            return true
        }
        else {
 
            return false
        }
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (validateFields()) {
            performSegue(withIdentifier: "showSubpage2", sender: self)
        } else {
            // Show errors if field not validated
        }
    }
}

class Subpage2ViewController: SubpageViewController {
    

    @IBOutlet var fitnessFrequency: [UIButton]!
    @IBOutlet var personalGoals: [UIButton]!
    @IBOutlet var ageGroup: [UIButton]!
    @IBOutlet var height: [UITextField]!
    @IBOutlet var weight: [UITextField]!
    @IBOutlet weak var errorAlertLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for btn in height {
            btn.keyboardType = .decimalPad
        }
        for btn in weight {
            btn.keyboardType = .decimalPad
        }
    }
    
    override func validateFields() -> Bool {
        
        errorAlertLabel.text = "Fields are missing!"
        errorAlertLabel.isHidden = true
        //I have no idea how to check if the segment index is selected at all or not
        //Using this spaghetti check to see if the user has selected a gender
        
        
        //check if an age group has been selected
        var ageSelected : Bool = false
        for button in ageGroup
        {
            if (button.isSelected)
            {
                ageSelected = true
            }
        }
        if (!ageSelected)
        {
            errorAlertLabel.text = "Age not selected!"
            errorAlertLabel.isHidden = false
            return false
        }
        //check if a goal has been selected
        var goalSelected : Bool = false
        for button in personalGoals
        {
            if (button.isSelected)
            {
                goalSelected = true
            }
        }
        if (!goalSelected)
        {
            errorAlertLabel.text = "Goals not selected!"
            errorAlertLabel.isHidden = false
            return false
        }
        
        //check if a frequency has been selected
        var freqSelected : Bool = false
        for button in fitnessFrequency
        {
            if (button.isSelected)
            {
                freqSelected = true
            }
        }
        if (!freqSelected)
        {
            errorAlertLabel.text = "Frequency not selected!"
            errorAlertLabel.isHidden = false
            return false
        }
        

        //Outline in red the textfields that are missing
        let textViews : [UITextField] = height + weight
        for textField in textViews
        {
            if (textField.text?.isEmpty)!
            {
                let myColor : UIColor = UIColor.red
                textField.layer.borderColor = myColor.cgColor
                textField.layer.borderWidth = 1
                errorAlertLabel.isHidden = false
                
            }
            else
            {
                textField.layer.borderWidth = 0
            }
        }
        if (errorAlertLabel.isHidden) {
            return true
        }
        else {
            
            return false
        }
    }
    
    @IBAction func selectFitnessFrequency(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in fitnessFrequency {
            if (button == sender) {
                button.isSelected = true
                
                // User has selected this particular fitness frequency.
                // Add/Update this value in the temp variable that will be later saved to local storage

            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func selectAgeGroup(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in ageGroup {
            if (button == sender) {
                button.isSelected = true
                
                // User has selected this particular age group.
                // Add/Update this value in the temp variable that will be later saved to local storage
                
            } else {
                button.isSelected = false
            }
        }
    }

    @IBAction func selectPersonalGoals(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)

        sender.isSelected = !sender.isSelected
        
        for button in personalGoals {
            if (button.isSelected) {
                // This value is selected as a personal goal.
                // Change values in the temp variable that will be later saved to local storage
            }
        }
    }
    
    @IBAction func updateWeight(_ sender: UITextField) {
        if (sender == weight[0]) { // If kg field was updated
            
            // Calculate the lb field
            if (weight[0].text != "") {
                let kg = Double(weight[0].text!)!
                let lb = kg * 2.2046
                weight[1].text = String(format: "%.1f", lb)
            }
            
        } else if (sender == weight[1]) { // If lb field was updated
            
            //Calculate the kg field
            if (weight[1].text != "") {
                let lb = Double(weight[1].text!)!
                let kg = lb / 2.2046
                weight[0].text = String(format: "%.1f", kg)
            }
        }
    }
    
    @IBAction func updateHeight(_ sender: UITextField) {
        if (sender == height[0]) { // If ft field was updated
            if (height[0].text != "") {
                // Add/Update this value in the temp variable that will be later saved to local storage
            }
            
        } else if (sender == height[1]) { // If inches field was updated
            if (height[1].text != "") {
                // Add/Update this value in the temp variable that will be later saved to local storage
            }
        }
    }

    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (validateFields()) {
            performSegue(withIdentifier: "showSubpage3", sender: self)
        } else {
            // Show errors if field not validated
        }
    }
    
}

class Subpage3ViewController: SubpageViewController {
    
    @IBOutlet var enableDisableSleepAnalysis: [UIButton]!
    
    @IBOutlet weak var errorAlertLabel: UILabel!
    let ENABLE_BUTTON_TAG = 100;
    let DISABLE_BUTTON_TAG = 200;
    
    override func validateFields() -> Bool {
        errorAlertLabel.isHidden = true
        var selected : Bool = false
        for button in enableDisableSleepAnalysis
        {
            if (button.isSelected)
            {
                selected = true
            }
        }
        if (!selected)
        {
            errorAlertLabel.text = "Select an option!"
            errorAlertLabel.isHidden = false
        }
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return selected
    }
    
    @IBAction func toggleEnableDisableSleep(_ sender: UIButton) {
        
        for button in enableDisableSleepAnalysis {
            if (sender == button) {
                button.isSelected = true
                if (button.tag == ENABLE_BUTTON_TAG) {
                    // Enable sleep analysis in the temp variable
                    let healthStore = HKHealthStore()
                    healthStore.requestAuthorization(toShare: nil, read: [HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!], completion: { (success, error) -> Void in
                        if success == false {
                            // User denied permission
                        }
                    })
                    
                } else if (button.tag == DISABLE_BUTTON_TAG) {
                    // Disable sleep analysis in the temp variable
                }
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (validateFields()) {
            performSegue(withIdentifier: "showSubpage4", sender: self)
        } else {
            // Show errors if field not validated
        }
    }
    
}

class Subpage4ViewController: SubpageViewController {
    
    @IBOutlet weak var errorAlertLabel: UILabel!
    @IBOutlet var enableDisableButton: [UIButton]!
    
    let ENABLE_BUTTON_TAG = 100;
    let DISABLE_BUTTON_TAG = 200;
    
    override func validateFields() -> Bool {
        errorAlertLabel.isHidden = true
        var selected : Bool = false
        for button in enableDisableButton
        {
            if (button.isSelected)
            {
                selected = true
            }
        }
        if (!selected)
        {
            errorAlertLabel.text = "Select an option!"
            errorAlertLabel.isHidden = false
        }
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return selected
    }
    
    @IBAction func toggleEnableDisable(_ sender: UIButton) {

        for button in enableDisableButton {
            if (sender == button) {
                button.isSelected = true
                if (button.tag == ENABLE_BUTTON_TAG) {
                    // Enable fitness buddy in the temp variable
                    
                } else if (button.tag == DISABLE_BUTTON_TAG) {
                    // Disable fitness buddy in the temp variable
                }
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func finishBtnAction(_ sender: Any) {
        if (validateFields()) {
            // Gather up all data from the 4 view controllers and add to local storage
            // This is where the persistence stuff would come in handy
        }
    }
    
    
}
