//
//  Day18.swift
//  AoC24
//
//  Created by Mike Lewis on 12/21/24.
//

import Foundation

func Day18(file: String, part: Int) -> String {
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
    
    let mapSize = file.contains("sample") ? Coordinate(x: 6, y: 6) : Coordinate(x: 70, y: 70)
    let startNode = Coordinate(x: 0, y: 0)
    let endNode = mapSize
    
    if part == 2 {
        var nodes: Set<Coordinate> = []
        var edges: Set<Edge> = []
        var shortestPath: [Coordinate] = []
        
        // Fill nodes with all map coords
        for x in 0...mapSize.x {
            for y in 0...mapSize.y {
                let coord = Coordinate(x: x, y: y)
                nodes.insert(coord)
            }
        }
        
        for node in nodes {
            for dir in dirVectors.keys {
                let coord = Coordinate(x: node.x + dirVectors[dir]!.x, y: node.y + dirVectors[dir]!.y)
                if nodes.contains(coord) {
                    edges.insert(Edge(start: node, end: coord))
                }
            }
        }
        
        dijkstra()
        
        for line in lines {
            let coords = line.split(separator: ",").map { Int($0)! }
            nodes.remove(Coordinate(x: coords[0], y: coords[1]))
            let edgesToRemove = edges.filter { $0.start == Coordinate(x: coords[0], y: coords[1]) || $0.end == Coordinate(x: coords[0], y: coords[1]) }
            edges.subtract(edgesToRemove)
            if shortestPath.contains(Coordinate(x: coords[0], y: coords[1])) {
                print("** \(line) in shortest path. Finding new shortest path")
                let newPathFound = dijkstra()
                if !newPathFound {
                    print("** Couldn't find new shortest path")
                    return "XXXXX"
                }
            } else {
                print("\(line) not in shortest path. Continuing")
            }
        }
        // START
        //        var numCorrupted = 0
        //        for line in lines {
        //            if numCorrupted == numToCorrupt { break }
        //            let coords = line.split(separator: ",").map { Int($0)! }
        //            nodes.remove(Coordinate(x: coords[0], y: coords[1]))
        //            numCorrupted += 1
        //        }
        
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
        return "Pt2"
    }
    
    
    
    if part == 3 {
        var nodes: Set<Coordinate> = []
        var edges: Set<Edge> = []
        
        // Fill nodes with all map coords
        for x in 0...mapSize.x {
            for y in 0...mapSize.y {
                let coord = Coordinate(x: x, y: y)
                nodes.insert(coord)
            }
        }
        
        let numToCorrupt = file.contains("sample") ? 12 : 1024
        var numCorrupted = 0
        for line in lines {
            if numCorrupted == numToCorrupt { break }
            let coords = line.split(separator: ",").map { Int($0)! }
            nodes.remove(Coordinate(x: coords[0], y: coords[1]))
            numCorrupted += 1
        }
        
        // Fill edges with all possible connections
        for node in nodes {
            for dir in dirVectors.keys {
                let coord = Coordinate(x: node.x + dirVectors[dir]!.x, y: node.y + dirVectors[dir]!.y)
                if nodes.contains(coord) {
                    edges.insert(Edge(start: node, end: coord))
                }
            }
        }
        

        var allPaths: Set< Set<Coordinate> > = []
        
        func getAllPath(from: Coordinate, to: Coordinate) {
            var visited: Set<Coordinate> = []
            var path: [Coordinate] = []
            
            path.append(from)
            
            getAllPathRecursive(from: from, to: to, visited: &visited, path: &path)
        }
        
        func getAllPathRecursive(from: Coordinate, to: Coordinate, visited: inout Set<Coordinate>, path: inout [Coordinate]) {
            
            if from == to {
                //                print(path.map( { $0.coordStr } ))
                allPaths.insert(Set(path))
                return
            }
            
            visited.insert(from)
            for edge in edges.filter( { $0.start == from } ) {
                if !visited.contains(edge.end) {
                    path.append(edge.end)
                    getAllPathRecursive(from: edge.end, to: to, visited: &visited, path: &path)
                    path.removeLast()
                }
            }
            
            visited.remove(from)
            
        }
        
        print("nodes: \(nodes.count), edges: \(edges.count)")
        getAllPath(from: Coordinate(x: 0, y: 0), to: mapSize)
        print("\(allPaths.count) different sets of nodes. \(allPaths.filter( { $0.contains(Coordinate(x: 1, y: 2)) } ).count) have 1,2")
        
        
        for line in lines[numToCorrupt..<lines.count] {
            let coords = line.split(separator: ",").map { Int($0)! }
            let pathsToRemove = allPaths.filter( { $0.contains(Coordinate(x: coords[0], y: coords[1])) } )
            allPaths.subtract(pathsToRemove)
            print("Removing \(pathsToRemove.count) paths that contain \(line). \(allPaths.count) remaining")
            if allPaths.isEmpty {
                print("All done! \(line)")
                return line
            }
        }
        //        for line in lines {
        //            let coords = line.split(separator: ",").map { Int($0)! }
        //            let node = Coordinate(x: coords[0], y: coords[1])
        //            for path in allPaths {
        //                <#body#>
        //            }
        //        }
        return "Done Pt 2"
    }
    
    
    let numToCorruptPt1 = file.contains("sample") ? 12 : 1024
    //        let numToCorruptPt2 = 0
    
    
    let numToCorruptMin = numToCorruptPt1
    let numToCorruptMax = (part == 1) ? numToCorruptPt1: lines.count
    var numToCorrupt = numToCorruptMin
    while numToCorrupt <= numToCorruptMax {
        var nodes: Set<Coordinate> = []
        var edges: Set<Edge> = []
        
        // Fill nodes with all map coords
        for x in 0...mapSize.x {
            for y in 0...mapSize.y {
                let coord = Coordinate(x: x, y: y)
                nodes.insert(coord)
            }
        }
        
        // START
        var numCorrupted = 0
        for line in lines {
            if numCorrupted == numToCorrupt { break }
            let coords = line.split(separator: ",").map { Int($0)! }
            nodes.remove(Coordinate(x: coords[0], y: coords[1]))
            numCorrupted += 1
        }
        
        for node in nodes {
            for dir in dirVectors.keys {
                let coord = Coordinate(x: node.x + dirVectors[dir]!.x, y: node.y + dirVectors[dir]!.y)
                if nodes.contains(coord) {
                    edges.insert(Edge(start: node, end: coord))
                }
            }
        }
        
        // Start Dijkstra
        let startNode = Coordinate(x: 0, y: 0)
        let endNode = mapSize
        var sptSet: Set<Coordinate> = []
        var dist: [Coordinate: Int] = [:]
        for node in nodes {
            dist[node] = Int.max
        }
        dist[startNode] = 0
        
        while sptSet.count != nodes.count {
            let notInSptSet = nodes.subtracting(sptSet)
            let minDistNode = dist.keys.filter( { notInSptSet.contains($0) } ).min(by: { dist[$0]! < dist[$1]! })!
            //        print("Moving to \(minDistNode.coordStr)")
            let minDist = dist[minDistNode]!
            if minDist == Int.max {
                print("Can't reach this node \(minDistNode.coordStr)")
                print("the offending line: \(numToCorrupt): \(lines[numToCorrupt-1])")
                return "\(lines[numToCorrupt-1])"
            }
            sptSet.insert(minDistNode)
            
            if minDistNode == endNode {
                if part == 1 {
                    print("We made it!")
                    print(minDist)
                    return("\(minDist)")
                }
                else {
                    //                    print("\(numToCorrupt): minDist = \(minDist)")
                    break
                }
            }
            
            for edge in edges where edge.start == minDistNode {
                let newDist = dist[minDistNode]! + edge.weight
                if newDist <= dist[edge.end]! {
                    //                print("Updating dist[\(edge.end.coordStr)] to \(newDist)")
                    dist[edge.end] = newDist
                }
            }
        }
        // END Dijkstra
        
        numToCorrupt += 1
    }
    
    
    
    
    
    
    
    
    print(tot)
    return "\(tot)"
}
