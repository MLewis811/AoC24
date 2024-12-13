//
//  DayTemplate.swift
//  AoC24
//
//  Created by Mike Lewis on 12/12/24.
//

import Foundation

func Day13(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    struct Button {
        let dx: Int
        let dy: Int
        let cost: Int
    }
    
    struct ClawMachine {
        let AButton: Button
        let BButton: Button
        
        let prize: (x: Int, y: Int)
        
        var cheapestCost: Int? = nil
        var pushes: (a: Int, b: Int) = (-1,-1)
    }
    
    struct Equation {
        var a: Int
        var b: Int
        var target: Int
    }
    
    var machines: [ClawMachine] = []
    
    var aButToAdd: Button = Button(dx: 0, dy: 0, cost: 0)
    var bButToAdd: Button = Button(dx: 0, dy: 0, cost: 0)
    var prizeLoc: (Int, Int)
    
    for line in lines {
        if line.hasPrefix("Button ") {
            let xInc = Int(line.split(separator: "X+")[1].split(separator: ",")[0])!
            let yInc = Int(line.split(separator: "Y+")[1].split(separator: ",")[0])!
            
            if line.hasPrefix("Button A") {
                aButToAdd = Button(dx: xInc, dy: yInc, cost: 3)
            } else {
                bButToAdd = Button(dx: xInc, dy: yInc, cost: 1)
            }
        } else if line.hasPrefix("Prize: ") {
            // get the prize location
            let xLoc = Int(line.split(separator: "X=")[1].split(separator: ",")[0])! + (part == 1 ? 0 : 10000000000000)
            let yLoc = Int(line.split(separator: "Y=")[1].split(separator: ",")[0])! + (part == 1 ? 0 : 10000000000000)
            prizeLoc = (xLoc, yLoc)
            // create the machine and add it to the list
            let mach = ClawMachine(AButton: aButToAdd, BButton: bButToAdd, prize: prizeLoc)
            machines.append(mach)
        }
    }
    
 
    for machNum in 0..<machines.count {
            
            let xEqn = Equation(a: machines[machNum].AButton.dx, b: machines[machNum].BButton.dx, target: machines[machNum].prize.x)
            let yEqn = Equation(a: machines[machNum].AButton.dy, b: machines[machNum].BButton.dy, target: machines[machNum].prize.y)
            
            let (aSol, bSol) = solveSystem(xEqn, yEqn)
            if let intX = Int(exactly: aSol), let intY = Int(exactly: bSol) {
                let cost = 3*intX + intY
                print("machine \(machNum): \(intX), \(intY) --- cost = \(3*intX + intY)")
                tot += cost
            } else {
//                print("Not ints")
            }
    }
    

    print(tot)
    return "\(tot)"
    
    func solveSystem(_ eqn1: Equation, _ eqn2: Equation) -> (x: Double, y: Double) {
        let mat1 = [[eqn1.a, eqn1.b],[eqn2.a, eqn2.b]]
        let mat2 = [[eqn1.target],[eqn2.target]]
        
        let det = mat1[0][0]*mat1[1][1] - mat1[0][1]*mat1[1][0]
        
        // Ought to add some error handling for systems with no (or infinitely many) solns
        assert( det != 0 )
        
        let invMat1 = [ [ mat1[1][1], -1*mat1[0][1] ],
                        [ -1*mat1[1][0], mat1[0][0] ]
        ]
        
        let x = Double(invMat1[0][0]*mat2[0][0] + invMat1[0][1]*mat2[1][0]) / Double(det)
        let y = Double(invMat1[1][0]*mat2[0][0] + invMat1[1][1]*mat2[1][0]) / Double(det)
        
        return (x,y)
    }
    
    func getSolutions(_ eqn: Equation) -> [(a: Int, b: Int)] {
        var a = eqn.a
        var b = eqn.b
        var target = eqn.target
        
        var solutions: [(a: Int, b: Int)] = []
        
        let gcd = gcd(eqn.a, eqn.b)
        
        if target % gcd != 0 {
            print("Can't solve \(a)x+\(b)y = \(target)")
            return []
        }
        
        a /= gcd
        b /= gcd
        target /= gcd
        
        let maxA = target / a
        var possAFound: Int? = nil
        var attemptA = maxA
        while attemptA >= 0 && possAFound == nil {
            if (target - (attemptA * a)) % b == 0 { possAFound = attemptA }
            attemptA -= 1
        }
        if possAFound == nil {
            return []
        }
        
        var solnA = possAFound!
        var solnB = (target - a * solnA) / b
        while solnA >= 0 && solnB <= target {
            solutions.append((solnA, solnB))
            solnA -= b
            solnB += a
        }
        
        return solutions
    }
}
