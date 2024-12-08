//
//  Day7.swift
//  AoC24
//
//  Created by Mike Lewis on 12/6/24.
//

import Foundation

func Day7(file: String, part: Int) -> String {
    
    enum Operator: String {
        case add = "+"
        case multiply = "*"
        case concatenate = "||"
    }
    
    struct Equation {
        let target: Int
        let numbers: [Int]
        var operators: [Operator] = []
        var currTarget: Int
        
        init(target: Int, numbers: [Int], operators: [Operator] = []) {
            self.target = target
            self.numbers = numbers
            self.operators = operators
            currTarget = target
        }
    }
    
    var tot = 0
    
    let lines = loadStringsFromFile(file)
    
    for line in lines {
        let target = Int(line.split(separator: ":")[0])!
        let nums = line.split(separator: ":")[1].split(separator: " ").map{Int($0)!}
        let eqn = Equation(target: target, numbers: nums)
        
//        print("*****")
//        printEqn(eqn)
        if dealWithLastNum(eqn) {
            tot += eqn.target
            print("\(eqn.target) Worked!")
        }
//        if addLastOp(&eqn, .multiply) {
//            printEqn(eqn)
//            removeLastOp(&eqn)
//            printEqn(eqn)
//        }
        //        print(allDone(eqn) ? "done" : eqn)
    }
    
    
    return "\(tot)"
    
    func dealWithLastNum(_ eqn: Equation) -> Bool {
        print("In dwln: \(printEqn(eqn))")
        if eqn.target == 1 && eqn.operators[0] == .multiply {
            return true
        }
        if eqn.target == 0 && eqn.operators[0] == .add {
            return true
        }
        if eqn.numbers.count == 0 {
            return false
        }
        
        if eqn.currTarget < eqn.numbers.last! {
            return false
        }
        
//        if eqn.operators.count == eqn.numbers.count - 1 {
//            if eqn.currTarget == eqn.numbers[0] {
//                return true
//            } else {
//                return false
//            }
//        }
        
        // if target ends w/ eqn.numbers.last
        //  newCurr = currTarget with numbers.last cut off the end
        if eqn.target > eqn.numbers.last! && "\(eqn.target)".hasSuffix("\(eqn.numbers.last!)") {
            let targetStr = "\(eqn.target)"
            let lastNumStr = "\(eqn.numbers.last!)"
            let newCurrent = Int(targetStr[0..<(targetStr.count-lastNumStr.count)])!
            let newNums = Array(eqn.numbers[0..<(eqn.numbers.count-1)])
            let newOps = [.concatenate] + eqn.operators
            let newEqn = Equation(target: newCurrent, numbers: newNums, operators: newOps)
            if dealWithLastNum(newEqn) {
                return true
            }
        }

        if eqn.currTarget % eqn.numbers.last! == 0 {
            let newCurrent = eqn.currTarget / eqn.numbers.last!
            let newNums = Array(eqn.numbers[0..<(eqn.numbers.count-1)])
            let newOps = [.multiply] + eqn.operators
            let newEqn = Equation(target: newCurrent, numbers: newNums, operators: newOps)
            if dealWithLastNum(newEqn) {
                return true
            }
        }
        
        let newCurrent = eqn.currTarget - eqn.numbers.last!
        let newNums = Array(eqn.numbers[0..<(eqn.numbers.count-1)])
        let newOps = [.add] + eqn.operators
        let newEqn = Equation(target: newCurrent, numbers: newNums, operators: newOps)
        if dealWithLastNum(newEqn) {
            return true
        }
        
        return false
    }
    
    func allDone(_ eqn: Equation) -> Bool {
        return (eqn.operators.count == eqn.numbers.count - 1) && (eqn.currTarget == eqn.numbers[0])
    }
    
    func printEqn(_ eqn: Equation) -> String {
        var ops: [String] = []
        for op in eqn.operators {
            ops.append(op.rawValue)
        }
        return "\(eqn.target) \(eqn.numbers) \(ops) \(eqn.currTarget)"
    }
}
