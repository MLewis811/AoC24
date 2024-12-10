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
    
    if part == 1 {
        
        while startLinePos <= endLinePos {
            let blockLen = Int(line[startLinePos])!
            if startLinePos % 2 == 0 { // in a file
                for _ in 0..<(startFileNum == endFileNum ? Int(line[endLinePos])! - endFileCount : blockLen) {
                    filledStr += "\(startFileNum)"
                    condensedStr += "\(startFileNum)"
                    tot += Int128(fillPos) * Int128(startFileNum)
                    print("fi: \(fillPos) * \(startFileNum) = \(Int128(fillPos)*Int128(startFileNum)) -- \(tot)")
                    fillPos += 1
                }
            } else { // in empty space
                for _ in 0..<blockLen {
                    if startLinePos <= endLinePos {
                        filledStr += "."
                        condensedStr += "\(endFileNum)"
                        tot += Int128(fillPos) * Int128(endFileNum)
                        print("mv: \(fillPos) * \(endFileNum) = \(Int128(fillPos)*Int128(endFileNum)) -- \(tot) -- \(startLinePos),\(endLinePos)")
                        fillPos += 1
                        endFileCount += 1
                        if endFileCount >= Int(line[endLinePos])! {
                            endFileNum -= 1
                            endFileCount = 0
                            endLinePos -= 2
                        }
                    }
                }
                startFileNum += 1
            }
            startLinePos += 1
        }
    } else {
        struct DiskPosition: Hashable {
            var fileNum: Int
            var len: Int
            var isEmpty: Bool
        }
        
        var diskPositions: [DiskPosition] = []
        while startLinePos < line.count {
            let blockLen = Int(line[startLinePos])!
            
            diskPositions += [DiskPosition(fileNum: startFileNum, len: blockLen, isEmpty: startLinePos % 2 != 0)]
            
            startFileNum += startLinePos % 2 != 0 ? 1 : 0
            startLinePos += 1
        }
        
        for i in 0..<10 {
            print("\(i): \(diskPositions[i].fileNum) \(diskPositions[i].len) \(diskPositions[i].isEmpty ? "empty" : "full")")
        }

        var posNum = diskPositions.count - 1
        
        while posNum >= 0 {
            
            if !diskPositions[posNum].isEmpty {
                let blockLen = diskPositions[posNum].len
                
                var posToSearch = 0
                while posToSearch < posNum {
                    if diskPositions[posToSearch].isEmpty && diskPositions[posToSearch].len >= blockLen {
                        if diskPositions[posToSearch].len == blockLen {
                            diskPositions[posToSearch].fileNum = diskPositions[posNum].fileNum
                            diskPositions[posToSearch].isEmpty = false
                        } else {
                            diskPositions.insert(DiskPosition(fileNum: -1, len: diskPositions[posToSearch].len - blockLen, isEmpty: true), at: posToSearch + 1)
                            posNum += 1 // Since the array is one longer now, the index of the end should move up by one
                            diskPositions[posToSearch].fileNum = diskPositions[posNum].fileNum
                            diskPositions[posToSearch].isEmpty = false
                            diskPositions[posToSearch].len = blockLen
                        }
                        diskPositions[posNum].isEmpty = true
                        posToSearch = posNum // break out of the while loop
                    }
                    posToSearch += 1
                }
            }
            posNum -= 1
        }
        
        print("**********")
        var posTot = 0
        for i in 0..<diskPositions.count {
            print("\(i): \(diskPositions[i].isEmpty ? "-" : "\(diskPositions[i].fileNum)") \(diskPositions[i].len) \(diskPositions[i].isEmpty ? "empty" : "full")")
            for _ in 0..<diskPositions[i].len {
                tot += diskPositions[i].isEmpty ? 0 : Int128(diskPositions[i].fileNum * posTot)
                posTot += 1
            }
        }
        
    }
//    print(filledStr)
//    print(condensedStr)
    
    print(tot)
    return "\(tot)"
}
