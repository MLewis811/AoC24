//
//  Day6.swift
//  AoC24
//
//  Created by Mike Lewis on 12/5/24.
//

import Foundation

func Day6(file: String, part: Int) -> String {
    
    struct Position: Hashable {
        let x: Int
        let y: Int
    }
    
    
    enum Direction {
        case north
        case south
        case east
        case west
        
        var nHeading: Int {
            switch self {
            case .north: return -1
            case .south: return 1
            case .east: return 0
            case .west: return 0
            }
        }
        
        var eHeading: Int {
            switch self {
            case .north: return 0
            case .south: return 0
            case .east: return 1
            case .west: return -1
            }
        }
        
        var rotatedRight: Direction {
            switch self {
            case .north: return .east
            case .south: return .west
            case .east: return .south
            case .west: return .north
            }
        }
    }
    
    struct Move: Hashable {
        let pos: Position
        let dir: Direction
    }

    var tot = 0

    let lines = loadStringsFromFile(file)
    
    var obstacles:Set<Position> = []
    var visited:Set<Position> = []
    let mapDims: (height: Int, width: Int) = (height: lines.count, width: lines[0].count)
    
    var currPos:Position = Position(x: 0, y: 0)
    var currDir:Direction = .north
    
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            let pos = Position(x: x, y: y)
            
            if lines[y][x] == "#" {
                obstacles.insert(pos)
            } else if lines[y][x] == "^" {
                currPos = pos
                currDir = .north
            } else if lines[y][x] == ">" {
                currPos = pos
                currDir = .east
            } else if lines[y][x] == "v" {
                currPos = pos
                currDir = .south
            } else if lines[y][x] == "<" {
                currPos = pos
                currDir = .west
            }
        }
    }
    
    let startPos = currPos
    let startDir = currDir
    
    for obstacle in obstacles {
        print("\(obstacle.x), \(obstacle.y)")
    }
    
    print("\(currPos.x), \(currPos.y) - \(currDir)")

    while onMap(currPos) {
        visited.insert(currPos)
        let nextPos = Position(x: currPos.x+currDir.eHeading, y:currPos.y+currDir.nHeading)
        if !obstacles.contains(nextPos) {
            currPos = nextPos
            print("\(currPos.x), \(currPos.y) - \(currDir)")
        } else {
            currDir = currDir.rotatedRight
            print("\(currPos.x), \(currPos.y) - \(currDir)")
        }
    }
    
    assert(obstacles.intersection(visited).isEmpty)
    
    if part == 1 {
        tot = visited.count

        return "\(tot)"
    }
    
    print("******** Starting Part 2 ***********")



    visited.remove(startPos)
    for candidate in visited {
        var path:Set<Move> = []
        currPos = startPos
        currDir = startDir
        obstacles.insert(candidate)
        // Walk and see if we loop
        var looped = false
        while !looped && onMap(currPos) {
            if path.contains(Move(pos: currPos, dir: currDir)) {
                looped = true
                print("Looped at \(candidate.x), \(candidate.y)")
                tot += 1
            } else {
                path.insert(Move(pos: currPos, dir: currDir))
                let nextPos = Position(x: currPos.x+currDir.eHeading, y:currPos.y+currDir.nHeading)
                if !obstacles.contains(nextPos) {
                    currPos = nextPos
//                    print("\(currPos.x), \(currPos.y) - \(currDir)")
                } else {
                    currDir = currDir.rotatedRight
//                    print("\(currPos.x), \(currPos.y) - \(currDir)")
                }
            }
        }
        
        
        obstacles.remove(candidate)
    }
    
    return "\(tot)"
    
    
    func onMap(_ pos: Position) -> Bool {
        pos.x >= 0 && pos.x < mapDims.width && pos.y >= 0 && pos.y < mapDims.height
    }
}
