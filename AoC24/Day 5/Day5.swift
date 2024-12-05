//
//  Day5.swift
//  AoC24
//
//  Created by Mike Lewis on 12/4/24.
//

import Foundation

func Day5(file: String, part: Int) -> String {
    let lines = loadStringsFromFile(file)
    
    var tot = 0
    
    var orderRules: [Int: Set<Int>] = [:]
    
    var section = 0
    for line in lines {
        if line == "" {
            section += 1
        } else {
            if section == 0 {
                let pages = line.split(separator: "|").map { Int($0)! }
                orderRules[pages[0], default: []].insert(pages[1])
            } else {
                let update = line.split(separator: ",").map { Int($0)! }
                var reversedUpdate = update
                reversedUpdate.reverse()
                var (foundBadOrder, pageNum) = invalidOrder(reversedUpdate)
                
                if part == 1 {
                    if !foundBadOrder {
                        let midPage = update[(update.count-1)/2]
                        print(midPage)
                        tot += midPage
                    }
                } else {
                    print("****\(line)")
                    while foundBadOrder {
                        var rotatedUpdate = Array(reversedUpdate[pageNum...])
                        moveFirstToEnd(&rotatedUpdate)
                        rotatedUpdate = reversedUpdate[0..<pageNum] + rotatedUpdate
                        reversedUpdate = rotatedUpdate
                        (foundBadOrder, pageNum) = invalidOrder(reversedUpdate)
                        if !foundBadOrder {
                            print("Fixed it! New order: \(reversedUpdate)")
                            let midPage = reversedUpdate[(reversedUpdate.count-1)/2]
                            print(midPage)
                            tot += midPage
                        }
                    }
                }
                
            }
        }
    }
    
    return "\(tot)"
    
    // If the pages are in an invalid order, return true & and the index in the array of the page that violates the order rules.
    // If the pages are not in an invalid order (IOW in a valid order), return false & 0. The Int value should not be used in this case.
    func invalidOrder(_ pages: [Int]) -> (Bool, Int) {
        for pageNum in 0..<pages.count-1 {
            let remainingPages = Set(pages[(pageNum+1)...])
            if !orderRules[pages[pageNum], default: []].intersection(remainingPages).isEmpty {
                return (true, pageNum)
            }
        }
        return (false, 0)
    }
    
    // Does what it says on the tin. Change [1,2,3,4] to [2,3,4,1]
    func moveFirstToEnd(_ pages: inout [Int]) {
        pages.append(pages.removeFirst())
    }
}
