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
        
        var coordStr: String {
            return "\(x),\(y)"
        }
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
    
    let trailheads = Set(mapPos.filter { $0.value == 0 }.map(\.key))
//    let peaks = Set(mapPos.filter { $0.value == 9 }.map(\.key))
    
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
//    printEdges(edges)
    
//    for trailhead in trailheads {
//        print("\(trailhead.x),\(trailhead.y) has neighbors \(getNeighbors(trailhead))")
//    }
//    print("3,3 has neighbors \(getNeighbors(Coordinate(x: 3, y: 3)))")
    
//    for peak in peaks {
//        print("\(peak.x),\(peak.y): \(mapPos[peak])")
//    }
    
    if part == 1 {
        // Begin BFS
        for trailhead in trailheads {
            var visited: Set<Coordinate> = []
            var queue: [Coordinate] = []
            queue.append(trailhead)
            while !queue.isEmpty {
                let current = queue.removeFirst()
                if visited.contains(current) { continue }
                visited.insert(current)
                queue.append(contentsOf: getNeighbors(current))
            }
            print("\(trailhead.coordStr) has score \(visited.filter { mapPos[$0] == 9 }.count)")
            tot += visited.filter { mapPos[$0] == 9 }.count
        }
        // End BFS
    } else {
        // Begin DFS
        for trailhead in trailheads {
            var rating = 0
            var visited: Set<Coordinate> = []
            var stack: [Coordinate] = []
            stack.append(trailhead)
            while !stack.isEmpty {
                let current = stack.removeLast()
                if mapPos[current] == 9 { rating += 1 }
//                if visited.contains(current) { continue }
                visited.insert(current)
                stack += getNeighbors(current)
            }
            print("\(trailhead.coordStr) has rating \(rating)")
            tot += rating
        }
        
        // End DFS
    }



    
    print(tot)
    return "\(tot)"
    
    func printEdges(_ edges: [Edge]) {
        for edge in edges {
            print("\(edge.start.x),\(edge.start.y) -> \(edge.end.x),\(edge.end.y)")
        }
    }
    
    func getNeighbors(_ coordinate: Coordinate) -> [Coordinate] {
        let neighbors: [Coordinate] = edges.filter { $0.start == coordinate }.map { $0.end }
        
        return neighbors
    }
}
