//
//  Day19.swift
//  AoC24
//
//  Created by Mike Lewis on 12/21/24.
//

import Foundation

func Day19(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    let choices = Set(lines[0].split(separator: ", ").map( { String($0) }))
    
    let targets = Array(lines[2...])
    
//    print( choices )
//    print( targets )
    
    var considered: [String: Int] = [:]
    
    for target in targets {
//        print("\(target) - \(findPossibility(target))")
        let numPossibilities = findPossibility(target)
        tot += part == 1 ? (numPossibilities > 0 ? 1 : 0) : numPossibilities
    }

    func findPossibility(_ target: String) -> Int {
        if target == "" {
//            print("In with empty string")
            return 1
        }
        
        if let alreadyDone = considered[target] {
            return alreadyDone
        }

//        print("In with \(target)")
//        if choices.contains(target) {
////            print("It's a match!")
//            considered[target] = 1
//            return 1
//        }
        considered[target] = 0
        
        let possibleChoices = choices.filter { target.hasPrefix($0) }
        
        var possibilityTotal = 0
        
        for possibleChoice in possibleChoices.sorted( by: { $0.count > $1.count } ) {
//            print("Removing \(possibleChoice) from \(target)")
            let newTarget = String(target[target.index(target.startIndex, offsetBy: possibleChoice.count)...])
            let nextPossibilityNum = findPossibility(newTarget)
            if nextPossibilityNum >= 1 {
                possibilityTotal += nextPossibilityNum
//                return nextPossibilityNum
            }
        }
        
        considered[target] = possibilityTotal
        return possibilityTotal
    }
    
    
    print(tot)
    return "\(tot)"
}
