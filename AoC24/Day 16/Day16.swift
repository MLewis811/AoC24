//
//  Day16.swift
//  AoC24
//
//  Created by Mike Lewis on 12/15/24.
//

import Foundation

func Day16(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    enum CardinalDirection: String, CaseIterable {
        case north
        case south
        case east
        case west
    }
    
    func oppDir(_ dir: CardinalDirection) -> CardinalDirection {
        switch dir {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
    
    struct MapCoordinate: Hashable {
        let x: Int
        let y: Int
    }
    
    struct Coordinate: Hashable {
        let coord: MapCoordinate
        let dir: CardinalDirection
        
        var coordStr: String {
            return "\(coord.x),\(coord.y) - \(dir.rawValue)"
        }
    }

    struct Edge: Hashable {
        let start: Coordinate
        let end: Coordinate
        
        var weight: Int {
            if start.coord == end.coord {
                return 1000
            }
            return 1
        }
    }
    
    let dirVectors: [CardinalDirection: MapCoordinate] = [
        .north: MapCoordinate(x: 0, y: -1),
        .south: MapCoordinate(x: 0, y: 1),
        .east: MapCoordinate(x: 1, y: 0),
        .west: MapCoordinate(x: -1, y: 0)
    ]
        
    
    var walls: Set<MapCoordinate> = []
    var hallways: Set<MapCoordinate> = []
    var start: MapCoordinate = MapCoordinate(x: -1, y: -1)
    var end: MapCoordinate = MapCoordinate(x: -1, y: -1)
    
    var nodes: Set<Coordinate> = []
    var edges: Set<Edge> = []
    
    func fillNodes() {
        for hallway in hallways {
            for dir in CardinalDirection.allCases {
//                let vector = dirVectors[dir]!
                nodes.insert(Coordinate(coord: hallway, dir: dir))
            }
            
        }
    }
    
    func fillEdges() {
        for node in nodes {
            let vector = dirVectors[node.dir]!
            let coord = MapCoordinate(x: node.coord.x + vector.x, y: node.coord.y + vector.y)
            // Move
            if nodes.contains(Coordinate(coord: coord, dir: node.dir)) {
                edges.insert(Edge(start: node, end: Coordinate(coord: coord, dir: node.dir)))
            }
            // Rotate 90 deg
            if node.dir == .north || node.dir == .south {
                edges.insert(Edge(start: node, end: Coordinate(coord: node.coord, dir: .east)))
                edges.insert(Edge(start: node, end: Coordinate(coord: node.coord, dir: .west)))
            } else {
                edges.insert(Edge(start: node, end: Coordinate(coord: node.coord, dir: .north)))
                edges.insert(Edge(start: node, end: Coordinate(coord: node.coord, dir: .south)))
            }
        }
    }
    
    // fill hallways and walls
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            let coord = MapCoordinate(x: x, y: y)
            switch lines[y][x] {
            case "#":
                walls.insert(coord)
            case ".", "S", "E":
                hallways.insert(coord)
                if lines[y][x] == "S" {
                    start = coord
                } else if lines[y][x] == "E" {
                    end = coord
                }
            default:
                break
            }
        }
    }
    
    // use hallways to fill nodes
    fillNodes()
    
    print("\(nodes.count) nodes")
    
    // use nodes to fill edges
    fillEdges()
    print("\(edges.count) nodes")

    let startEdges = edges.filter( { $0.start.coord == start } )
    for edge in startEdges {
        print("\(edge.start.coordStr) -> \(edge.end.coordStr)")
    }
    
    var sptSet: Set<Coordinate> = []
    var dist: [Coordinate: Int] = [:]
    for node in nodes {
        dist[node] = Int.max
    }
    dist[Coordinate(coord: start, dir: .east)] = 0
    
    while sptSet.count != nodes.count {
        let notInSptSet = nodes.subtracting(sptSet)
        var minDistNode = dist.keys.filter( { notInSptSet.contains($0) } ).min(by: { dist[$0]! < dist[$1]! })!
        var minDist = dist[minDistNode]!
        sptSet.insert(minDistNode)
        
        if minDistNode.coord == end {
            print("We made it!")
            print(minDist)
            return("\(minDist)")
        }

        
        for edge in edges where edge.start == minDistNode {
            let newDist = dist[minDistNode]! + edge.weight
            if newDist < dist[edge.end]! {
//                print("Updating dist[\(edge.end.coordStr)] to \(newDist)")
                dist[edge.end] = newDist
            }
        }
        
    }
    

    
    print(tot)
    return "\(tot)"
    

}