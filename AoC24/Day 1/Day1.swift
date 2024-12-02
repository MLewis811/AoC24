//
//  Day1.swift
//  AoC24
//
//  Created by Mike Lewis on 11/25/24.
//

import Foundation

func Day1(file: String, part: Int) -> String {
    let lines = loadStringsFromFile(file)
    
    var left: [Int] = []
    var right: [Int] = []
    
    var tot = 0
    
    for line in lines {
        var nums = line.split(separator: " ").map {Int($0)!}
    
        left.append(nums[0])
        right.append(nums[1])
    }
    
    if part == 1 {
        left.sort()
        right.sort()
        
        print(left)
        print(right)
        
        for (l, r) in zip(left, right) {
            print("\(l) \(r) \(abs(l-r))")
            tot += abs(l - r)
        }
    } else {
        var lcounts: [Int: Int] = [:]
        var rcounts: [Int: Int] = [:]
        
        for l in left {
            lcounts[l, default: 0] += 1
        }
        
        for r in right {
            rcounts[r, default: 0] += 1
        }
        
        for key in lcounts.keys {
            if rcounts[key] != nil {
                tot += lcounts[key]! * rcounts[key]! * key
            }
        }
    }

        
    return "\(tot)"
}
