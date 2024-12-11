//
//  Day11.swift
//  AoC24
//
//  Created by Mike Lewis on 12/11/24.
//

import Foundation

func Day11(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    
    let stones = lines[0].split(separator: " ").map { Int($0)! }

    var stoneCount: [Int: Int] = [:]
    
    var stoneOutput: [Int: [Int]] = [:]
    
    for stone in stones {
        stoneCount[stone, default: 0] += 1
    }
    print(stoneCount)

    
    let startTime = CFAbsoluteTimeGetCurrent()
    let numBlinks = part == 1 ? 25 : 75
    for _ in 0..<numBlinks {
//        stones = blink(stones)
        stoneCount = blinkCounts(stoneCount)
//        print(stones)
//        print(stoneCount)
    }
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(numBlinks) blink cycles: \(timeElapsed)")
    
    for (_, count) in stoneCount {
        tot += count
    }

    
    
    print(tot)
    return "\(tot)"
    
    // Smarter plan: Count how many stones we have of a #, and add that many stones of each new number.
    // Also, keep a list of what the output is for a given #, so that we don't have to figure it out again later.
    func blinkCounts( _ stoneCount: [Int : Int] ) -> [Int: Int] {
        var newStoneCount: [Int: Int] = [:]
        for (stone, count) in stoneCount {
            if let output = stoneOutput[stone] {
                for newStone in output {
                    newStoneCount[newStone, default: 0] += count
                }
            } else {
                if stone == 0 {
                    newStoneCount[1, default: 0] += count
                    stoneOutput[stone] = [1]
                } else if String(stone).count % 2 == 0 {
                    let halfIdx = String(stone).count / 2
                    let left = Int(String(stone)[0..<halfIdx])!
                    let right = Int(String(stone)[halfIdx...])!
                    newStoneCount[left, default: 0] += count
                    newStoneCount[right, default: 0] += count
                    stoneOutput[stone] = [left, right]
                } else {
                    newStoneCount[stone * 2024, default: 0] += count
                    stoneOutput[stone] = [stone * 2024]
                }
            }
        }
        
        return newStoneCount
    }
    
    // Brute force - actually create all the stones.
    // The list of stones gets really long really fast, so this isn't sustainable.
    func blink(_ stones: [Int]) -> [Int] {
        var newStones: [Int] = []
        for stone in stones {
            if stone == 0 {
                newStones.append(1)
            } else if String(stone).count % 2 == 0 {
                let halfIdx = String(stone).count / 2
                let left = Int(String(stone)[0..<halfIdx])!
                let right = Int(String(stone)[halfIdx...])!
                newStones += [left, right]
            } else {
                newStones.append(stone * 2024)
            }
        }
        return newStones
    }
}
