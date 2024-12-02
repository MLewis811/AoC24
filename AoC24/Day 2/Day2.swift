//
//  Day1.swift
//  AoC24
//
//  Created by Mike Lewis on 11/25/24.
//

import Foundation

func Day2(file: String, part: Int) -> String {
    let lines = loadStringsFromFile(file)
    
    var tot = 0
    
    for line in lines {
        let report = line.split(separator: " ").map { Int($0)! }
        
        
        let (safe, unsafeIdx) = isSafe(report)
        
//        let candidates = report[0..<i] + report[(i+1)...]
//        print(candidates)

        
        if safe {
            tot += 1
            print("\(report) -> \(safe): tot = \(tot)")
        } else {
            print("\(report) unsafe at \(unsafeIdx)")
            let candidates = [[Int](report[0..<unsafeIdx] + report[(unsafeIdx+1)...]),
                              [Int](report[0...unsafeIdx] + report[(unsafeIdx+2)...]),
                              [Int](report[1...])]
            print(candidates)
            for candidate in candidates {
                let (safe, unsafeIdx) = isSafe(candidate)
                if safe {
                    print("   \(candidate) -> \(safe)")
                    tot += 1
                    print("\(report) -> \(safe): tot = \(tot)")
                    break
                } else {
                    print("   \(candidate) unsafe at \(unsafeIdx)")
                }
            }
        }
        
//        print("\(line) -> \(safe)")
    }
    
    return "\(tot)"
}

func isSafe(_ report: [Int]) -> (Bool, Int) {
    var safe = true

    let increasing = report[1] > report[0]

    
    var i = 0
    var unsafeIdx = -1
    while safe && i < report.count-1 {
        if (abs(report[i] - report[i+1]) > 3
            || report[i] == report[i+1]
            || increasing != (report[i+1] > report[i])) {
            safe = false
            unsafeIdx = i
        }
        
        i += 1
    }
    
    return (safe, unsafeIdx)
}
