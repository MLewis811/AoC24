//
//  Day20.swift
//  AoC24
//
//  Created by Mike Lewis on 12/20/24.
//

import Foundation

func Day20(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    enum CardinalDirection: String, CaseIterable {
        case north
        case south
        case east
        case west
    }
    
    struct Coordinate: Hashable {
        let x: Int
        let y: Int
        
        var coordStr: String {
            return "\(x),\(y)"
        }
    }
    
    let dirVectors: [CardinalDirection: Coordinate] = [
        .north: Coordinate(x: 0, y: -1),
        .south: Coordinate(x: 0, y: 1),
        .east: Coordinate(x: 1, y: 0),
        .west: Coordinate(x: -1, y: 0)
    ]
    
    struct Edge: Hashable {
        let start: Coordinate
        let end: Coordinate
        
        var weight: Int {
            1
        }
    }
    
    var shortestPath: [Coordinate] = []
    
    var nodes: Set<Coordinate> = []
    var walls: Set<Coordinate> = []
    var edges: Set<Edge> = []
    
    var startNode: Coordinate = Coordinate(x: -1, y: -1)
    var endNode: Coordinate = Coordinate(x: -1, y: -1)
    
    // initialize nodes and walls
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            switch lines[y][x] {
            case ".":
                nodes.insert(Coordinate(x: x, y: y))
            case "S":
                nodes.insert(Coordinate(x: x, y: y))
                startNode = Coordinate(x: x, y: y)
            case "E":
                nodes.insert(Coordinate(x: x, y: y))
                endNode = Coordinate(x: x, y: y)
            default:
                walls.insert(Coordinate(x: x, y: y))
            }
        }
    }
    
    // initialize edges
    for node in nodes {
        for dir in dirVectors.keys {
            let coord = Coordinate(x: node.x + dirVectors[dir]!.x, y: node.y + dirVectors[dir]!.y)
            if nodes.contains(coord) {
                edges.insert(Edge(start: node, end: coord))
            }
        }
    }
    
    dijkstra()
    
//    print(shortestPath.map(\.coordStr))
    
    var pathDist: [Coordinate: Int] = [:]
    for i in 0..<shortestPath.count {
        pathDist[shortestPath[i]] = i
    }
    
    let threshold = 100
    let cheatLen = part == 1 ? 2 : 20
 
    for i in 0..<shortestPath.count {
        let cheatStart = shortestPath[i]
        tot += nodes.filter( { taxicabDistance(cheatStart, $0) <= cheatLen && pathDist[$0]! - pathDist[cheatStart]! - taxicabDistance(cheatStart, $0) >= threshold } ).count
//            tot += 1
//            print("\(cheatStart.coordStr) -> \(end.coordStr) saves \(pathDist[end]! - pathDist[cheatStart]! - cheatLen)")
    }
    
//    for i in 0..<shortestPath.count {
//        let cheatStart = shortestPath[i]
//        for dir in dirVectors.keys {
//            let vector = dirVectors[dir]!
//            if walls.contains(Coordinate(x: cheatStart.x + vector.x, y: cheatStart.y + vector.y)) {
//                let cheatEnd = Coordinate(x: cheatStart.x + vector.x * 2, y: cheatStart.y + vector.y * 2)
//                if nodes.contains(cheatEnd) {
//                    if pathDist[cheatEnd]! - pathDist[cheatStart]! - 2 >= threshold {
//                        tot += 1
//                        print("\(cheatStart.coordStr) -> \(cheatEnd.coordStr) saves \(pathDist[cheatEnd]! - pathDist[cheatStart]! - 2)")
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
    
    print(tot)
    return "\(tot)"
    
    func dijkstra() -> Bool {
        // Start Dijkstra
        var sptSet: Set<Coordinate> = []
        var dist: [Coordinate: Int] = [:]
        
        shortestPath = []
        
        for node in nodes {
            dist[node] = Int.max
        }
        dist[startNode] = 0
        
        var parents: [Coordinate: Coordinate] = [:]
        
        while sptSet.count != nodes.count {
            let notInSptSet = nodes.subtracting(sptSet)
            let minDistNode = dist.keys.filter( { notInSptSet.contains($0) } ).min(by: { dist[$0]! < dist[$1]! })!
            //        print("Moving to \(minDistNode.coordStr)")
            let minDist = dist[minDistNode]!
            if minDist == Int.max {
                return false
            }
            sptSet.insert(minDistNode)
            
            if minDistNode == endNode {
//                    print("We made it!")
//                    print(minDist)
                constructPath(from: startNode, to: endNode)
//                    print(shortestPath.map( { $0.coordStr } ))
                return true
            }
            
            for edge in edges where edge.start == minDistNode {
                let newDist = dist[minDistNode]! + edge.weight
                if newDist <= dist[edge.end]! {
                    //                print("Updating dist[\(edge.end.coordStr)] to \(newDist)")
                    dist[edge.end] = newDist
                    parents[edge.end] = minDistNode
                }
            }
        }
        // END Dijkstra
        
        return false
        
        func constructPath(from: Coordinate, to: Coordinate) {
            if from == to {
                shortestPath.append(from)
                return
            }
            
            constructPath(from: from, to: parents[to]!)
            shortestPath.append(to)
            
        }
    }
    
    func taxicabDistance(_ a: Coordinate, _ b: Coordinate) -> Int {
        return abs(a.x - b.x) + abs(a.y - b.y)
    }
}
