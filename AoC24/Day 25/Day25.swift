//
//  Day25.swift
//  AoC24
//
//  Created by Mike Lewis on 1/2/25.
//

import Foundation

func Day25(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    struct Component {
        var column: [Int] = Array(repeating: 0, count: 5)
    }
    
    var locks: [Component] = []
    var keys: [Component] = []
    
    
    var comp = Component()
    var isLock = false
    for i in 0..<lines.count {
        switch i % 8 {
        case 0:
            isLock = lines[i] == "#####"
            if lines[i] == "#####" {
                print("Lock")
            } else {
                print("Key")
            }
        case 1...5:
            for j in 0..<lines[i].count {
                if lines[i][j] == "#" {
                    comp.column[j] += 1
                }
            }
        case 6:
            if isLock {
                locks.append(comp)
            } else {
                keys.append(comp)
            }
            isLock = false
            comp = Component()
        default:
            break
        }
    }
    
    for lock in locks {
        print("Lock: \(lock.column)")
    }
    for key in keys {
        print("Key: \(key.column)")
    }
    
    for lock in locks {
        for key in keys {
            var outStr = "L\(lock.column) K\(key.column) - "
            var overlap = false
            var i = 0
            while !overlap && i < lock.column.count {
                overlap = lock.column[i] + key.column[i] > 5
                i += 1
            }
            outStr += overlap ? "Overlap" : "No overlap"
            print(outStr)
            if !overlap {
                tot += 1
            }
        }
    }
    

    print(tot)
    return "\(tot)"
}
