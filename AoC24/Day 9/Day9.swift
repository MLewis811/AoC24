//
//  Day9.swift
//  AoC24
//
//  Created by Mike Lewis on 12/9/24.
//

import Foundation

func Day9(file: String, part: Int) -> String {
    var tot: Int128 = 0
    let lines = loadStringsFromFile(file)
    
    let line = lines[0]
    let maxFileNum = line.count / 2
    
    print(line.count)
    print(maxFileNum)
    
    var startFileNum = 0
    var endFileNum = maxFileNum
    var startFileCount = 0
    var endFileCount = 0
    var startLinePos = 0
    var endLinePos = line.count - 1
    
    var fillPos = 0
    
    var filledStr = ""
    var condensedStr = ""
    
    var currLastFileCount = 0
    
    var fileLength: [Int:Int] = [:]
    
    var fileNum = 0
    for i in 0..<line.count {
        if i % 2 == 0 {
            fileLength[fileNum] = Int(line[i])!
            fileNum += 1
        }
    }
    print(fileLength.sorted { $0.key < $1.key })
    
    while startLinePos <= endLinePos {
        let blockLen = Int(line[startLinePos])!
        if startLinePos % 2 == 0 { // in a file
            for _ in 0..<(startFileNum == endFileNum ? Int(line[endLinePos])! - endFileCount : blockLen) {
                filledStr += "\(startFileNum)"
                condensedStr += "\(startFileNum)"
                tot += Int128(fillPos) * Int128(startFileNum)
                print("\(fillPos) * \(startFileNum) = \(Int128(fillPos)*Int128(startFileNum)) -- \(tot)")
                fillPos += 1
            }
        } else { // in empty space
            for _ in 0..<blockLen {
                filledStr += "."
                condensedStr += "\(endFileNum)"
                tot += Int128(fillPos) * Int128(endFileNum)
                print("\(fillPos) * \(endFileNum) = \(Int128(fillPos)*Int128(endFileNum)) -- \(tot)")
                fillPos += 1
                endFileCount += 1
                if endFileCount >= Int(line[endLinePos])! {
                    endFileNum -= 1
                    endFileCount = 0
                    endLinePos -= 2
                }
            }
            startFileNum += 1
        }
        startLinePos += 1
    }
//    print(filledStr)
//    print(condensedStr)
    
    print(tot)
    return "\(tot)"
}
