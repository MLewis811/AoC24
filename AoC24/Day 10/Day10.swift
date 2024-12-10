//
//  Day10.swift
//  AoC24
//
//  Created by Mike Lewis on 12/10/24.
//

import Foundation

func Day10(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }
    
    var mapPos: [Coordinate: Int] = [:]
    
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            let pos = Coordinate(x: x, y: y)
            if lines[y][x] != "." {
                mapPos[pos] = Int(lines[y][x])
            }
        }
    }
    
    struct Edge: Hashable {
        let start: Coordinate
        let end: Coordinate
    }
    
    for (key, value) in mapPos {
        print("\(key.x),\(key.y): \(value)")
    }
    
    // Build all the edges (directional)
    var edges: [Edge] = []
    for (key, value) in mapPos {
        var neighbor = Coordinate(x: key.x + 1, y: key.y) //east
        if mapPos[neighbor] == value + 1 { edges.append(Edge(start: key, end: neighbor)) }

        neighbor = Coordinate(x: key.x - 1, y: key.y) // west
        if mapPos[neighbor] == value + 1 { edges.append(Edge(start: key, end: neighbor)) }

        neighbor = Coordinate(x: key.x, y: key.y - 1) // north
        if mapPos[neighbor] == value + 1 { edges.append(Edge(start: key, end: neighbor)) }

        neighbor = Coordinate(x: key.x, y: key.y + 1) // south
        if mapPos[neighbor] == value + 1 { edges.append(Edge(start: key, end: neighbor)) }
        
    }
    printEdges(edges)


    
    print(tot)
    return "\(tot)"
    
    func printEdges(_ edges: [Edge]) {
        for edge in edges {
            print("\(edge.start.x),\(edge.start.y) -> \(edge.end.x),\(edge.end.y)")
        }
    }
}
