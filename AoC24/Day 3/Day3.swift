//
//  Day3.swift
//  AoC24
//
//  Created by Mike Lewis on 12/2/24.
//

import Foundation

func Day3(file: String, part: Int) -> String {
    let lines = loadStringsFromFile(file)
    
    var tot = 0
    
    var enabled = 1
    
    for line in lines {
        print(line)
        var i = 0
        while i < line.count {
            if line[i...].hasPrefix("mul(") {
                i += 4
                let remainder = line[i...]
                print(remainder)
                if (remainder.contains(",") && remainder.split(separator: ",")[1].contains(")")) {
                    let first = remainder.split(separator: ",")[0]
                    let second = remainder.split(separator: ",")[1].split(separator: ")")[0]
                    print(first)
                    print(second)
                    if let firstInt = Int(first), let secondInt = Int(second) {
                        print(firstInt)
                        print(secondInt)
                        let result = firstInt * secondInt
                        print(result)
                        tot += result * (part == 1 ? 1 : enabled)
                        print("Total is now \(tot)")
                    }
                }
            } else if line[i...].hasPrefix("do()") {
                i += 4
                print("Enabled!")
                enabled = 1
            } else if line[i...].hasPrefix("don't()") {
                i += 7
                print("Disabled!")
                enabled = 0
            } else {
                i += 1
            }
        }
    }
    
    return "\(tot)"
}
