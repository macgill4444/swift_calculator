//
//  ViewController.swift
//  Calculator
//
//  Created by Macgill Davis on 8/21/15.
//  Copyright (c) 2015 Macgill Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false
   
    var brain = CalculatorBrain()
    
    //make sure with action you dont choose anyobject
    @IBAction func appendDigit(sender: UIButton) {
        //let same as var but constant, make sure you put a type
        let digit = sender.currentTitle!
        //when using ! it unwraps optional and when that value is not set then it crashes
        
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
 
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            //newValue is a magic variable
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clearCalc() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 0
        brain.clear()
    }
    
}

