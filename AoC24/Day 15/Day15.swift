//
//  Day15.swift
//  AoC24
//
//  Created by Mike Lewis on 12/14/24.
//

import Foundation

func Day15(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    
    struct Coordinate: Hashable, Equatable {
        let x: Int
        let y: Int
        
        var gpsCoord: Int {
            100 * y + x
        }
        
        static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }
    
    enum CardinalDirection: String {
        case north
        case south
        case west
        case east
    }
    
    var dirVector: [CardinalDirection: (x: Int, y: Int)] = [:]
    dirVector[.north] = (0,-1)
    dirVector[.south] = (0,1)
    dirVector[.west] = (-1,0)
    dirVector[.east] = (1,0)
    
    var movesStr = ""
    var walls: Set<Coordinate> = []
    var boxes: Set<Coordinate> = [] // part 1: coord of box. part 2: coord of WEST HALF of box
    var eastBoxes: Set<Coordinate> = [] // only used in part 2: coord of EAST HALF of box
    var robot: Coordinate = Coordinate(x: -1, y: -1)
    
    var moves: [CardinalDirection] = []
    
    var linesForMap: [String] = []
    
    if part == 2 {
        // build our double-wide map
        for y in 0..<lines.count {
            if lines[y].hasPrefix("#") {
                var lineForMap = ""
                for x in 0..<lines[y].count {
                    switch lines[y][x] {
                    case "#" :
                        lineForMap += "##"
                    case "O":
                        lineForMap += "[]"
                    case "@":
                        lineForMap += "@."
                    case ".":
                        lineForMap += ".."
                    default:
                        break
                    }
                }
                linesForMap.append(lineForMap)
            } else {
                linesForMap.append(lines[y])
            }
        }
    } else {
        linesForMap = lines
    }
    
    for i in 0..<linesForMap.count {
        print(linesForMap[i])
    }
    
    
    for y in 0..<linesForMap.count {
        if linesForMap[y].hasPrefix("#") {
            for x in 0..<linesForMap[0].count {
                switch linesForMap[y][x] {
                case "#":
                    walls.insert(Coordinate(x: x, y: y))
                case "O", "[":
                    boxes.insert(Coordinate(x: x, y: y))
                case "@":
                    robot = Coordinate(x: x, y: y)
                case "]" :
                    eastBoxes.insert(Coordinate(x: x, y: y))
                default:
                    break
                }
            }
        } else {
            movesStr += linesForMap[y]
        }
    }
    
    var mapSize = (wid: lines[0].count * 2, hgt: lines.count)
    mapSize.hgt = walls.map( { $0.y } ).max()! + 1
    
    for i in 0..<movesStr.count {
        switch movesStr[i] {
        case "^":
            moves.append(.north)
        case "v":
            moves.append(.south)
        case "<":
            moves.append(.west)
        case ">":
            moves.append(.east)
        default:
            break
        }
    }
    
//    robot = Coordinate(x: 7, y: 5)
//    printMap(title: "Initial map")
//    var dir = CardinalDirection.north
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    
//    dir = .east
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    
//    dir = .south
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    
//    dir = .east
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    
//    dir = .east
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    
//    dir = .north
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    
//    dir = .north
//    robot = doDoubledMove(obj: robot, dir: dir)
//    printMap(title: "Move \(dir.rawValue)")
//    return "test"

    for move in moves {
        robot = (part == 1) ? doMove(obj: robot, dir: move) : doDoubledMove(obj: robot, dir: move)
//        printMap(title: "Move \(move.rawValue)")
    }
    
    for box in boxes {
        tot += box.gpsCoord
    }
    
    func doDoubledMove(obj: Coordinate, dir: CardinalDirection) -> Coordinate {
        let vector = dirVector[dir]!
        let newLoc = Coordinate(x: obj.x+vector.x, y: obj.y+vector.y)
        
//        print("*** checking \(newLoc.x),\(newLoc.y)")
        
        
        if walls.contains(newLoc) { // can't move, return original loc
            return obj
        }
        
        switch dir {
        case .west:
            if eastBoxes.contains(newLoc) {  // we are pushing the right side of a box
                let leftBox = Coordinate(x: newLoc.x - 1, y: newLoc.y)
                let newLeftBox = doDoubledMove(obj: leftBox, dir: dir)
                if newLeftBox == leftBox { // couldn't move, return original loc
                    return obj
                }
                boxes.insert(newLeftBox)
                boxes.remove(leftBox)
                eastBoxes.insert(Coordinate(x:newLeftBox.x + 1, y: newLeftBox.y))
                eastBoxes.remove(newLoc)
            }
        case .east:
            if boxes.contains(newLoc) {  // we are pushing the left side of a box
                let rightBox = Coordinate(x: newLoc.x + 1, y: newLoc.y)
                let newRightBox = doDoubledMove(obj: rightBox, dir: dir)
                if newRightBox == rightBox { // couldn't move, return original loc
                    return obj
                }
                boxes.insert(Coordinate(x:newRightBox.x - 1, y: newRightBox.y))
                boxes.remove(newLoc)
                eastBoxes.insert(newRightBox)
                eastBoxes.remove(rightBox)
            }
        case .north, .south:
            var affectedSpaces: Set<Coordinate> = []
            if boxes.contains(newLoc) || eastBoxes.contains(newLoc) { // we're pushing on a box
//                print("Pushing a box")
                let vector = dirVector[dir]!
                let adjLeft = Coordinate(x: newLoc.x + vector.x + (boxes.contains(newLoc) ? 0 : -1), y: newLoc.y + vector.y)
                let adjRight = Coordinate(x: adjLeft.x + 1, y: adjLeft.y)
                    
                affectedSpaces.insert(adjLeft)
                affectedSpaces.insert(adjRight)
//                print("affected: \(affectedSpaces)")
//                print("boxes: \(boxes)")
//                print("intersection: \(affectedSpaces.intersection(boxes))")
                while !affectedSpaces.intersection(boxes).isEmpty ||
                        !affectedSpaces.intersection(eastBoxes).isEmpty ||
                        !affectedSpaces.intersection(walls).isEmpty {
                    let space = affectedSpaces.popFirst()!
                    if walls.contains(space) {
                        return obj
                    } else if boxes.contains(space) {
                        affectedSpaces.insert(Coordinate(x: space.x + vector.x, y: space.y + vector.y))
                        affectedSpaces.insert(Coordinate(x: space.x + vector.x + 1, y: space.y + vector.y))
                    } else if eastBoxes.contains(space) {
                        affectedSpaces.insert(Coordinate(x: space.x + vector.x, y: space.y + vector.y))
                        affectedSpaces.insert(Coordinate(x: space.x + vector.x - 1, y: space.y + vector.y))
                    }
//                    print(affectedSpaces)
                    if !affectedSpaces.intersection(walls).isEmpty { // something is hitting a wall, can't move!
//                        print("Bailing because of \(affectedSpaces.intersection(walls))")
                        return obj
                    }
                }
            }
            // START: All of this works, unless we push a "pyramid" of boxes. Then part of the pyramid moves,
            // even when the whole pyramid can't.
            if boxes.contains(newLoc) { // we are pushing the left side of a box
                let leftBox = newLoc
                let rightBox = Coordinate(x: leftBox.x + 1, y: leftBox.y)
                
                let newLeft = doDoubledMove(obj: leftBox, dir: dir)
                let newRight = doDoubledMove(obj: rightBox, dir: dir)
                if newLeft == leftBox || newRight == rightBox {
                    return obj
                }
                assert(newRight == Coordinate(x: newLeft.x + 1, y: newLeft.y))
                boxes.insert(newLeft)
                boxes.remove(leftBox)
                eastBoxes.insert(newRight)
                eastBoxes.remove(rightBox)
            } else if eastBoxes.contains(newLoc) { // we are pushing the right side of a box
                let rightBox = newLoc
                let leftBox = Coordinate(x: rightBox.x - 1, y: rightBox.y)
                
                let newLeft = doDoubledMove(obj: leftBox, dir: dir)
                let newRight = doDoubledMove(obj: rightBox, dir: dir)
                if newLeft == leftBox || newRight == rightBox {
                    return obj
                }
                assert(newRight == Coordinate(x: newLeft.x + 1, y: newLeft.y))
                boxes.insert(newLeft)
                boxes.remove(leftBox)
                eastBoxes.insert(newRight)
                eastBoxes.remove(rightBox)
            }
            // END

        }

//        var boxesToMove: [Coordinate] = []
//        var coordToCheck = Coordinate(x: robot.x+vector.x, y: robot.y+vector.y)
//        while boxes.contains(coordToCheck) {
//
//        }
        
        
        return newLoc
    }
    
    func doMove(obj: Coordinate, dir: CardinalDirection) -> Coordinate {
        let vector = dirVector[dir]!
        let newLoc = Coordinate(x: obj.x+vector.x, y: obj.y+vector.y)
        
//        print("checking \(newLoc.x),\(newLoc.y)")
        
        
        if walls.contains(newLoc) { // can't move, return original loc
            return obj
        }
        
        if boxes.contains(newLoc) { // try to move the box
            let newBox = doMove(obj: newLoc, dir: dir)
            if newLoc == newBox { // couldn't move, return original loc
                return obj
            }
            boxes.insert(newBox)
            boxes.remove(newLoc)
        }
        
//        var boxesToMove: [Coordinate] = []
//        var coordToCheck = Coordinate(x: robot.x+vector.x, y: robot.y+vector.y)
//        while boxes.contains(coordToCheck) {
//            
//        }
        
        
        return newLoc
    }
    
    func printMap(title: String) {
        print(title)
        
        for y in 0..<mapSize.hgt {
            var strToPrint = ""
            var x = 0
            while x < mapSize.wid {
                let coord = Coordinate(x: x, y: y)
                if walls.contains(coord) { strToPrint += "#" }
                else if boxes.contains(coord) {
                    if part == 1 {
                        strToPrint += "O"
                    } else {
                        strToPrint += "[]"
                        x += 1
                    }
                }
                else if robot == coord { strToPrint += "@" }
                else { strToPrint += "." }
                x += 1
            }
            print(strToPrint)
        }
        
        print("")
    }

    print(tot)
    return "\(tot)"
}
