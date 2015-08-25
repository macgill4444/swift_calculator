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
    
    @IBOutlet weak var variableButton: UIButton!
    
    var userIsInTheMiddleOfTypingANumber = false
   
    var numberHasDecimalPoint = false
    
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
        operationsLabel.text = brain.getOpStack()
    }

    @IBAction func pushVariableOntoStack() {
        userIsInTheMiddleOfTypingANumber = false
        numberHasDecimalPoint = false
        if let result = brain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func setVariable() {
        userIsInTheMiddleOfTypingANumber = false
        numberHasDecimalPoint = false
        if let newVarVal = displayValue {
            brain.variableValues["M"] = newVarVal
            if let newDisplayValue = brain.evaluate() {
                displayValue = newDisplayValue
            }
        }
    }
   
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        numberHasDecimalPoint = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = nil
        }
        operationsLabel.text = brain.getOpStack()        
    }
    
    
    @IBAction func decimalPoint() {
        if userIsInTheMiddleOfTypingANumber && !numberHasDecimalPoint {
            numberHasDecimalPoint = true
            display.text = display.text! + "."
        } else if !numberHasDecimalPoint {
            numberHasDecimalPoint = true
            userIsInTheMiddleOfTypingANumber = true
            display.text = "0."
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
                display.text = "nan"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clearCalc() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 0
        brain.clear()
        operationsLabel.text = brain.getOpStack()
    }
    
    @IBAction func undo() {
        if userIsInTheMiddleOfTypingANumber {
            //remove the last character from display
            if var text = display.text {
                var textLength = count(text)
                if textLength >= 2 {
                    display.text = dropLast(text)
                } else if textLength == 1 {
                    display.text = " "
                }
            }
            
        } else {
            brain.undo()
            operationsLabel.text = brain.getOpStack()
            if let newDisplayValue = brain.evaluate() {
                displayValue = newDisplayValue
            }
        }
    }
    
}

