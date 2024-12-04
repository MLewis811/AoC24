//
//  Day4.swift
//  AoC24
//
//  Created by Mike Lewis on 12/3/24.
//

import Foundation

struct Position: Hashable {
    let row: Int
    let col: Int
}

struct WordSearchPosition {
    let char: Character
    var isIncluded: Bool = false
}

func Day4(file: String, part: Int) -> String {
    let lines = loadStringsFromFile(file)
    
    var tot = 0
    
    var ws:[Position: WordSearchPosition] = [:]
    
    for row in 0..<lines.count {
        let line = lines[row]
        for col in 0..<line.count {
            let c = line[line.index(line.startIndex, offsetBy: col)]
            ws[Position(row: row, col: col)] = WordSearchPosition(char: c)
        }
    }
    
    if part == 1 {
        for row in 0..<lines.count {
            for col in 0..<lines[row].count {
                let p = Position(row: row, col: col)
                if ws[p]?.char == "X" {
                    
                    // Look N
                    if row >= 3 {
                        if (ws[Position(row: row-1, col: col)]?.char == "M" && ws[Position(row: row-2, col: col)]?.char == "A" && ws[Position(row: row-3, col: col)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row-1, col: col)]?.isIncluded = true
                            ws[Position(row: row-2, col: col)]?.isIncluded = true
                            ws[Position(row: row-3, col: col)]?.isIncluded = true
                        }
                    }
                    
                    // Look NE
                    if row >= 3 && col < lines[row].count-3 {
                        if (ws[Position(row: row-1, col: col+1)]?.char == "M" && ws[Position(row: row-2, col: col+2)]?.char == "A" && ws[Position(row: row-3, col: col+3)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row-1, col: col+1)]?.isIncluded = true
                            ws[Position(row: row-2, col: col+2)]?.isIncluded = true
                            ws[Position(row: row-3, col: col+3)]?.isIncluded = true
                        }
                    }
                    
                    // Look E
                    if col < lines[row].count-3 {
                        if (ws[Position(row: row, col: col+1)]?.char == "M" && ws[Position(row: row, col: col+2)]?.char == "A" && ws[Position(row: row, col: col+3)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row, col: col+1)]?.isIncluded = true
                            ws[Position(row: row, col: col+2)]?.isIncluded = true
                            ws[Position(row: row, col: col+3)]?.isIncluded = true
                        }
                    }
                    
                    // Look SE
                    if row < lines.count-3 && col < lines[row].count-3 {
                        if (ws[Position(row: row+1, col: col+1)]?.char == "M" && ws[Position(row: row+2, col: col+2)]?.char == "A" && ws[Position(row: row+3, col: col+3)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row+1, col: col+1)]?.isIncluded = true
                            ws[Position(row: row+2, col: col+2)]?.isIncluded = true
                            ws[Position(row: row+3, col: col+3)]?.isIncluded = true
                        }
                    }
                    
                    // Look S
                    if row < lines.count-3 {
                        if (ws[Position(row: row+1, col: col)]?.char == "M" && ws[Position(row: row+2, col: col)]?.char == "A" && ws[Position(row: row+3, col: col)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row+1, col: col)]?.isIncluded = true
                            ws[Position(row: row+2, col: col)]?.isIncluded = true
                            ws[Position(row: row+3, col: col)]?.isIncluded = true
                        }
                    }
                    
                    // Look SW
                    if row < lines.count-3 && col >= 3 {
                        if (ws[Position(row: row+1, col: col-1)]?.char == "M" && ws[Position(row: row+2, col: col-2)]?.char == "A" && ws[Position(row: row+3, col: col-3)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row+1, col: col-1)]?.isIncluded = true
                            ws[Position(row: row+2, col: col-2)]?.isIncluded = true
                            ws[Position(row: row+3, col: col-3)]?.isIncluded = true
                        }
                    }
                    
                    // Look W
                    if col >= 3 {
                        if (ws[Position(row: row, col: col-1)]?.char == "M" && ws[Position(row: row, col: col-2)]?.char == "A" && ws[Position(row: row, col: col-3)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row, col: col-1)]?.isIncluded = true
                            ws[Position(row: row, col: col-2)]?.isIncluded = true
                            ws[Position(row: row, col: col-3)]?.isIncluded = true
                        }
                    }
                    
                    // Look NW
                    if row >= 3 && col >= 3 {
                        if (ws[Position(row: row-1, col: col-1)]?.char == "M" && ws[Position(row: row-2, col: col-2)]?.char == "A" && ws[Position(row: row-3, col: col-3)]?.char == "S") {
                            tot += 1
                            ws[p]?.isIncluded = true
                            ws[Position(row: row-1, col: col-1)]?.isIncluded = true
                            ws[Position(row: row-2, col: col-2)]?.isIncluded = true
                            ws[Position(row: row-3, col: col-3)]?.isIncluded = true
                        }
                    }
                    
                }
            }
        }
    }
    else {
        for row in 1..<lines.count-1 {
            for col in 1..<lines[row].count-1 {
                let p = Position(row: row, col: col)
                if ws[p]?.char == "A" {
                    var sw = ""
                    sw = sw + String(ws[Position(row: row-1, col: col-1)]!.char)
                    sw = sw + String(ws[Position(row: row, col: col)]!.char)
                    sw = sw + String(ws[Position(row: row+1, col: col+1)]!.char)
                    
                    var ne = ""
                    ne = ne + String(ws[Position(row: row-1, col: col+1)]!.char)
                    ne = ne + String(ws[Position(row: row, col: col)]!.char)
                    ne = ne + String(ws[Position(row: row+1, col: col-1)]!.char)
                    
                    if (sw == "SAM" || sw == "MAS") && (ne == "SAM" || ne == "MAS") {
                        tot += 1
                        ws[p]?.isIncluded = true
                        ws[Position(row: row-1, col: col-1)]?.isIncluded = true
                        ws[Position(row: row+1, col: col+1)]?.isIncluded = true
                        ws[Position(row: row-1, col: col+1)]?.isIncluded = true
                        ws[Position(row: row+1, col: col-1)]?.isIncluded = true
                    }
                    
                }
            }
        }
    }
    
    printGrid(ws, lines.count, lines[0].count)
    return "\(tot)"
}



func printGrid(_ grid: [Position: WordSearchPosition], _ numRows: Int, _ numCols: Int) {
    for row in 0..<numRows {
        var rowText = ""
        for col in 0..<numCols {
            if let position = grid[Position(row: row, col: col)] {
                if position.isIncluded {
                    rowText = rowText + String(position.char)
                }
                else {
                    rowText = rowText + "."
                }
            }
        }
        print(rowText)
    }
}
