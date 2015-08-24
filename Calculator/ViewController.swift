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
    
    @IBOutlet weak var operationsLabel: UILabel!
    
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
                displayValue = nil
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    
    @IBAction func decimalPoint() {
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + "."
        } else {
            display.text = "0."
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    var displayValue: Double? {
        get {
            if let doubleVal =  NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return doubleVal
            } else {
                return nil
            }
        }
        set {
            //newValue is a magic variable
            if let newDisplayVal = newValue {
                display.text = "\(newDisplayVal)"
            } else {
                display.text = "error"
            }
            userIsInTheMiddleOfTypingANumber = false
            operationsLabel.text = brain.getOpStack()
        }
    }
    
    @IBAction func clearCalc() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 0
        brain.clear()
    }
    
    @IBAction func undo() {
        brain.undo()
    }
    
}

