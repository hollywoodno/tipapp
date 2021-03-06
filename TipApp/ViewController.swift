//
//  ViewController.swift
//  TipApp
//
//  Created by hollywoodno on 3/10/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

struct PercentRange {
    let titles: [String]
    let ranges: [Double]
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var totalTipTextField: UITextField!
    @IBOutlet weak var tipPercentControl: UISegmentedControl!
    @IBOutlet weak var totalTextField: UITextField!
    
    let defaults = UserDefaults.standard
    
    let lowerRange = PercentRange(titles: ["5%", "10%", "13%"], ranges: [0.05, 0.10, 0.13])
    let midRange = PercentRange(titles: ["15%", "20%", "25%"], ranges: [0.15, 0.20, 0.25])
    let higherRange = PercentRange(titles: ["18%", "25%", "30%"], ranges: [0.18, 0.25, 0.30])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Need to set a default for the range of actual percentages
        // which is going to default to the midrange
        defaults.set(midRange.ranges, forKey: "defaultTipRange")
        
        // Load all user default preferences
        tipPercentControl.selectedSegmentIndex = defaults.integer(forKey: "defaultTipPercent")
        
        // Set up bill text field
        billTextField.textAlignment = .right
        billTextField.text = defaults.string(forKey: "lastBillAmount")
        
        if billTextField.text == "" || (billTextField.text == nil) {
            billTextField.placeholder = String(0.00)
        }
        
        billTextField.becomeFirstResponder()
        
        // Set up tipping range in UI
        for i in 0..<midRange.titles.count {
            tipPercentControl.setTitle(midRange.titles[i], forSegmentAt: i)
        }
        
        defaults.set(midRange.ranges, forKey: "defaultTipRange")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This helps keeps bill textfield up-to-date
        billUpdate(self)

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss keyboard when clicking outside bill text field
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    //MARK: Total bill updates
    
    // Updates tip amount and total each time
    // the value of bill changes
    @IBAction func billUpdate(_ sender: AnyObject) {
        let tipPercentRange = defaults.array(forKey: "defaultTipRange") as! [Double]
        print(type(of:  tipPercentRange))
        
        let bill = Double(billTextField.text!) ?? 0.00
        let calculateTip = tipPercentRange[tipPercentControl.selectedSegmentIndex] * bill
        
        totalTipTextField.text = String(format: "%.2f", calculateTip)
        totalTextField.text = String(format: "%.2f", calculateTip + bill)
//
//        // Update last entered
//        // TODO:
//        // Find if there is cleaner way to do this
        defaults.set(billTextField.text!, forKey: "lastBillAmount")
        
        if billTextField.text == "" || (billTextField.text == nil) {
            billTextField.placeholder = String(0.00)
        }
        
    }
    
    
    //MARK: Adjust set of tip percentage ranges based on service
    // TODO:
    // Lower and higher will both have their on tipPercentRange
    @IBAction func lowerTipRange(_ sender: Any) {
        // Set up tipping range in UI
        for i in 0..<lowerRange.titles.count {
            tipPercentControl.setTitle(lowerRange.titles[i], forSegmentAt: i)
        }
        
        defaults.set(lowerRange.ranges, forKey: "defaultTipRange")
        billUpdate(self)
    }
    
    @IBAction func resetTipRange(_ sender: Any) {
        for i in 0..<midRange.titles.count {
            tipPercentControl.setTitle(midRange.titles[i], forSegmentAt: i)
        }
        
        defaults.set(midRange.ranges, forKey: "defaultTipRange")
        billUpdate(self)
        
    }
    
    @IBAction func raiseTipRange(_ sender: Any) {
        for i in 0..<higherRange.titles.count {
            tipPercentControl.setTitle(higherRange.titles[i], forSegmentAt: i)
        }
        
        defaults.set(higherRange.ranges, forKey: "defaultTipRange")
        billUpdate(self)
    }
    
    // TODO:
    // If users manually add a tip amount instead of percentage
    // I will calculate tip percentage for user based on provided
    // tip dollar amount. That tip percentage will then be listed
    // as custom.
}

