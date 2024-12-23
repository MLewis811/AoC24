//
//  Day17.swift
//  AoC24
//
//  Created by Mike Lewis on 12/18/24.
//

import Foundation

func Day17(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    var register: [String: Int] = [:]
    var origRegister: [String: Int] = [:]
    
    var program: [Int] = []
    var output: [Int] = []
    
    func combo(_ operand: Int) -> Int {
        switch operand {
        case 0...3:
            return operand
        case 4:
            return register["A"]!
        case 5:
            return register["B"]!
        case 6:
            return register["C"]!
        default:
            return -1
        }
    }
    
    func runProgram() -> [Int] {
        var output: [Int] = []
        var instPtr = 0
        while instPtr < program.count {
            let inst = program[instPtr]
            let operand = (inst == 3 && register["A"] == 0) ? -1 : program[instPtr + 1]
            
            switch inst {
            case 0:
                print("Performing \(inst),\(operand)")
                register["A"] = register["A"]! / Int(pow(2, Double(combo(operand))))
                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 1:
                print("Performing \(inst),\(operand)")
                register["B"] = register["B"]! ^ operand
                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 2:
                print("Performing \(inst),\(operand)")
                register["B"] = combo(operand) % 8
                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 3:
                if register["A"] != 0 {
                    print("Jumping to \(operand)")
                    instPtr = operand - 2 // The instPtr will be incremented by 2 at the end, so we're subtracting 2 here
                }
            case 4:
                print("Performing \(inst),\(operand)")
                register["B"] = register["B"]! ^ register["C"]!
                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 5:
                print("Updating output with operand \(operand)")
                output.append(combo(operand) % 8)
                print("New output: \(output)")
            case 6:
                print("Performing \(inst),\(operand)")
                register["B"] = register["A"]! / Int(pow(2, Double(combo(operand))))
                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 7:
                print("Performing \(inst),\(operand)")
                register["C"] = register["A"]! / Int(pow(2, Double(combo(operand))))
                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            default:
                print("We should not be here!")
                assert(false)
                break
            }
            
            instPtr += 2
        }
        
        return output
        
    }
    
    func runPt2Program(want: [Int]) -> Bool {
//        print("Looking for \(want), A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
        var output: [Int] = []
        var instPtr = 0
        while instPtr < program.count {
            let inst = program[instPtr]
            let operand = (inst == 3 && register["A"] == 0) ? -1 : program[instPtr + 1]
            
            switch inst {
            case 0:
//                print("Performing \(inst),\(operand)")
                register["A"] = register["A"]! / Int(pow(2, Double(combo(operand))))
//                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 1:
//                print("Performing \(inst),\(operand)")
                register["B"] = register["B"]! ^ operand
//                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 2:
//                print("Performing \(inst),\(operand)")
                register["B"] = combo(operand) % 8
//                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 3:
                if register["A"] != 0 {
//                    print("Jumping to \(operand)")
                    instPtr = operand - 2 // The instPtr will be incremented by 2 at the end, so we're subtracting 2 here
                }
            case 4:
//                print("Performing \(inst),\(operand)")
                register["B"] = register["B"]! ^ register["C"]!
//                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 5:
//                print("Updating output with operand \(operand)")
                output.append(combo(operand) % 8)
//                print("New output: \(output)")
                if Array(want[0..<output.count]) != output {
//                    print("Want: \(want), Output: \(output) - FAIL")
                    return false
                }
            case 6:
//                print("Performing \(inst),\(operand)")
                register["B"] = register["A"]! / Int(pow(2, Double(combo(operand))))
//                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            case 7:
//                print("Performing \(inst),\(operand)")
                register["C"] = register["A"]! / Int(pow(2, Double(combo(operand))))
//                print("A: \(register["A"]!) B: \(register["B"]!) C: \(register["C"]!)")
            default:
                print("We should not be here!")
                assert(false)
                break
            }
            
            instPtr += 2
        }
        
        return (want.count == output.count)

    }
    
    // Load the registers and the program
    for line in lines {
        if line.hasPrefix("Register ") {
            let parts = line[9...].split(separator: ": ")
            register[String(parts[0])] = Int(parts[1])!
        } else if line.hasPrefix("Program: ") {
            program = line[9...].split(separator: ",").map { Int($0)! }
        }
    }
    
    print(register)
    for (key, val) in register {
        origRegister[key] = val
    }
    print(program)
    
    if part == 1 {
        output = runProgram()
        print(output)
        var outStr = ""
        for num in output {
            outStr += "\(num),"
        }
        outStr.removeLast()
        print(outStr)
    } else {
        var matchFound = false
        var i = 49368472505 // start at 50550367075
        while !matchFound {
            i += 1
            register["A"] = i
            register["B"] = origRegister["B"]
            register["C"] = origRegister["C"]
            matchFound = runPt2Program(want: program)
        }
        print("Match found at \(i)")
    }

//
//    print(output)
//    print(register)
//    print(program)
//    

    

    print(tot)
    return "\(tot)"
}
