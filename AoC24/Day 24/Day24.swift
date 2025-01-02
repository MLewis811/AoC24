//
//  Day24.swift
//  AoC24
//
//  Created by Mike Lewis on 12/25/24.
//

import Foundation

func Day24(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    var wires: [String: Bool] = [:]
    for line in lines {
        if line.contains( ": " ) {
            let split = line.split(separator: ": ")
            let wire = String(split[0])
            let value = (split[1] == "1")
            wires[wire] = value
        }
    }
    
    for (wire, value) in wires {
        print("\(wire): \(value)")
    }

    print(tot)
    return "\(tot)"
}
