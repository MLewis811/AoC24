//
//  Day9.swift
//  AoC24
//
//  Created by Mike Lewis on 12/9/24.
//

import Foundation

func Day9(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    let line = lines[0]
    let maxFileNum = line.count / 2
    
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
    
    while startLinePos <= endLinePos {
        let blockLen = Int(line[startLinePos])!
        if startLinePos % 2 == 0 { // in a file
            for _ in 0..<blockLen {
                filledStr += "\(startFileNum)"
                condensedStr += "\(startFileNum)"
            }
        } else { // in empty space
            for _ in 0..<blockLen {
                filledStr += "."
            }
            startFileNum += 1
        }
        startLinePos += 1
    }
    print(filledStr)
    
    print(tot)
    return "\(tot)"
}
