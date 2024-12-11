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
    
    
    var stones = lines[0].split(separator: " ").map { Int($0)! }

    var stoneCount: [Int: Int] = [:]
    
    for stone in stones {
        stoneCount[stone, default: 0] += 1
    }
    print(stoneCount)

    let numBlinks = part == 1 ? 25 : 75
    for _ in 0..<numBlinks {
//        stones = blink(stones)
        stoneCount = blinkCounts(stoneCount)
//        print(stones)
//        print(stoneCount)
    }
    
    for (_, count) in stoneCount {
        tot += count
    }

    
    
    print(tot)
    return "\(tot)"
    
    func blinkCounts( _ stoneCount: [Int : Int] ) -> [Int: Int] {
        var newStoneCount: [Int: Int] = [:]
        for (stone, count) in stoneCount {
            if stone == 0 {
                newStoneCount[1, default: 0] += count
            } else if String(stone).count % 2 == 0 {
                let halfIdx = String(stone).count / 2
                let left = Int(String(stone)[0..<halfIdx])!
                let right = Int(String(stone)[halfIdx...])!
                newStoneCount[left, default: 0] += count
                newStoneCount[right, default: 0] += count
            } else {
                newStoneCount[stone * 2024, default: 0] += count
            }
        }
        
        return newStoneCount
    }
    
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
