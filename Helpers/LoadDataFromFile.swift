//
//  LoadDataFromFile.swift
//  SonarSweep
//
//  Created by Mike Lewis on 12/3/21.
//

import Foundation

func loadDataFromFile(_ file: String) -> Data {
    guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
        fatalError("Failed to locate \(file)")
    }
    
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Failed to load \(file)")
    }
    
    return data
}

func loadStringsFromFile(_ file: String) -> [String] {
    let rawData = loadDataFromFile(file)
    var output: [String] = []
    
    let data = String(decoding: rawData, as: UTF8.self)
    let lines = data.split(separator: "\n", omittingEmptySubsequences: false)
    for line in lines {
        output.append(String(line))
    }
    
    if let lastLine = output.last {
        if lastLine.isEmpty {
            output.removeLast()
        }
    }
    
    return output
}

// Assumes one Int per line in file
func loadIntsFromFile(_ file: String) -> [Int] {
    let inStrings = loadStringsFromFile(file)
    
    var outputInts: [Int] = []
    
    
    for (_, text) in inStrings.enumerated() {
        outputInts.append(Int(text) ?? 0)
    }
    
    return outputInts
}
