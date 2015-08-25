//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Macgill Davis on 8/23/15.
//  Copyright (c) 2015 Macgill Davis. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let variable):
                    return variable + "\(variable)"
                }
            }
        }
    }
    private var opStack = [Op]()
    
    var opStackString: String
    
    
//    var knownOps = Dictionary<String, Op>()
    private var knownOps = [String:Op]()

    var variableValues = [String:Double]()
    
    init() {
        knownOps["x"] = Op.BinaryOperation("x", *)
        knownOps["/"] = Op.BinaryOperation("/") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
        knownOps["mod"] = Op.BinaryOperation("mod") { $1 % $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["π"] = Op.Operand(M_PI)
        opStackString = " "
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let variable):
                return (variableValues[variable], remainingOps)
            case .UnaryOperation(let symbol, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    opStackString = "\(operand)" + symbol + opStackString
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
//                        opStackString = "(\(operand1)" + symbol + "\(operand2))" + opStackString
                        opStackString = "(" + symbol + opStackString + ")"
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
//        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double?) -> Double? {
        if let newOperand = operand {
            opStack.append(Op.Operand(newOperand))
        }
        return evaluate()
    }
    
    func pushOperand(variable: String) -> Double? {
            opStack.append(Op.Variable(variable))
            return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll(keepCapacity: true)
        opStackString = ""
    }
    
    func undo() {
        if opStack.count > 0 {
            opStack.removeLast()
        }
    }
    
    func getOpStack() -> String {
        return stringifyStack(opStack).result! + "="
    }
    
    
    
    private func stringifyStack(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Variable(let variable):
                return (variable, remainingOps)
            case .UnaryOperation(let symbol, let operation):
                let operandEvaluation = stringifyStack(remainingOps)
                if let operand = operandEvaluation.result {
                    return (symbol + " (\(operand)) ", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, let operation):
                let op1Evaluation = stringifyStack(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = stringifyStack(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return ("(\(operand2) " + symbol + " \(operand1))", op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return ("", ops)
    }
    
}