//
//  Day12.swift
//  AoC24
//
//  Created by Mike Lewis on 12/11/24.
//

import Foundation

func Day12(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    struct Coordinate: Hashable {
        let x: Int
        let y: Int
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    enum CardinalDirection {
        case north
        case south
        case east
        case west
    }
    
    struct Side: Hashable {
        var start: Coordinate
        var end: Coordinate
        
        let direction: Direction
        let inside: CardinalDirection
    }
    
    struct Region: Hashable {
        let plant: String
        var coordinates: Set<Coordinate>
        
        var coordStr: String {
            var outStr = ""
            for coordinate in coordinates {
                outStr += "\(coordinate.x),\(coordinate.y) "
            }
            
            return outStr
        }
        
        var area: Int {
            coordinates.count
        }
        
        var perimeter: Int {
            return fenceCoords.count
        }
        
        var price: Int {
            area * perimeter
        }
        
        var fenceCoords: Set<Coordinate> {
            var fences: Set<Coordinate> = []
            for plantCoord in coordinates {
                let nbors = neighbors(plantCoord)
                for nbor in nbors {
                    if !coordinates.contains(nbor) {
                        if nbor.x == plantCoord.x {                // if nbor is n or s of plantCoord, need horiz fence
                            let fenceX = plantCoord.x * 2 + 1
                            let fenceY = (nbor.y == plantCoord.y - 1) ? plantCoord.y * 2 : plantCoord.y * 2 + 2
//                            if nbor.y == plantCoord.y-1 {           // north
//                                let fenceY = plantCoord.y * 2
//                            } else {                                // south
//                                let fenceY = plantCoord.y * 2 + 2
//                            }
                            fences.insert(Coordinate(x: fenceX, y: fenceY))
                        } else if nbor.y == plantCoord.y {          // if nbor is e or w of plantCoord, need vert fence
                            let fenceY = plantCoord.y * 2 + 1
                            let fenceX = (nbor.x == plantCoord.x - 1) ? plantCoord.x * 2 : plantCoord.x * 2 + 2
//                            if nbor.x == plantCoord.x-1 {           // west
//                                let fenceX = plantCoord.x * 2
//                            } else {                                // east
//                                let fenceX = plantCoord.x * 2 + 2
//                            }
                            fences.insert(Coordinate(x: fenceX, y: fenceY))
                        }
                    }
                }
            }
            
            return fences
        }
        
        var sides: [Side] {
            var sideSet: [Side] = []
            
            let horizFences = fenceCoords.filter { $0.x % 2 != 0 }
            let vertFences = fenceCoords.filter { $0.x % 2 == 0 }
            
//            guard let _ = theFences.first else { return sideSet }
            
//            if firstFence.x % 2 == 0 {
//                let start = Coordinate(x: firstFence.x, y: firstFence.y - 1)
//                let end = Coordinate(x: firstFence.x, y: firstFence.y + 1)
//                sideSet.insert(Side(start: start, end: end, direction: .vertical))
//            } else {
//                let start = Coordinate(x: firstFence.x - 1, y: firstFence.y)
//                let end = Coordinate(x: firstFence.x + 1, y: firstFence.y)
//                sideSet.insert(Side(start: start, end: end, direction: .horizontal))
//            }
            

            for fenceCoord in horizFences.sorted(by: { $0.x < $1.x }) {
                let start = Coordinate(x: fenceCoord.x - 1, y: fenceCoord.y)
                let end = Coordinate(x: fenceCoord.x + 1, y: fenceCoord.y)
                let thisDir: Direction = .horizontal
                let insideDir: CardinalDirection = coordinates.contains(Coordinate(x: (fenceCoord.x - 1) / 2, y: (fenceCoord.y - 2) / 2)) ? .north : .south
                
//                let sameDirSides = sideSet.filter { $0.direction == thisDir }
//                print("Looking at \(fenceCoord.x), \(fenceCoord.y): \(start.x), \(start.y) -> \(end.x), \(end.y)")
                
                if sideSet.filter({ $0.direction == thisDir }).isEmpty {
//                    print("Adding \(thisDir == .vertical ? "vert" : "hor") \(start.x), \(start.y) -> \(end.x), \(end.y)")
                    sideSet.append( Side( start: start, end: end, direction: thisDir, inside: insideDir ) )
                } else {

                    var addedToExistingSide = false
                    for i in 0..<sideSet.count {
                        if sideSet[i].direction == thisDir && sideSet[i].start == end && sideSet[i].inside == insideDir {
//                            print("Joining \(start.x), \(start.y) -> \(end.x), \(end.y) with existing side \(sideSet[i].start.x), \(sideSet[i].start.y) -> \(sideSet[i].end.x), \(sideSet[i].end.y)")
                            sideSet[i].start = start
                            addedToExistingSide = true
                        } else if sideSet[i].direction == thisDir && sideSet[i].end == start && sideSet[i].inside == insideDir {
                            sideSet[i].end = end
                            addedToExistingSide = true
                        }
                    }
                    
                    if !addedToExistingSide {
                        sideSet.append( Side(start: start, end: end, direction: thisDir, inside: insideDir) )
                    }
                }
                
            }
            
            for fenceCoord in vertFences.sorted(by: { $0.y < $1.y }) {
                let start = Coordinate(x: fenceCoord.x, y: fenceCoord.y - 1)
                let end = Coordinate(x: fenceCoord.x, y: fenceCoord.y + 1)
                let thisDir: Direction = .vertical
                let insideDir: CardinalDirection = coordinates.contains(Coordinate(x: (fenceCoord.x - 2) / 2, y: (fenceCoord.y - 1) / 2)) ? .west : .east
                
//                let sameDirSides = sideSet.filter { $0.direction == thisDir }
//                print("Looking at \(fenceCoord.x), \(fenceCoord.y): \(start.x), \(start.y) -> \(end.x), \(end.y)")
                
                if sideSet.filter({ $0.direction == thisDir }).isEmpty {
//                    print("Adding \(thisDir == .vertical ? "vert" : "hor") \(start.x), \(start.y) -> \(end.x), \(end.y)")
                    sideSet.append(Side(start: start, end: end, direction: thisDir, inside: insideDir))
                } else {

                    var addedToExistingSide = false
                    for i in 0..<sideSet.count {
                        if sideSet[i].direction == thisDir && sideSet[i].start == end && sideSet[i].inside == insideDir {
//                            print("Joining \(start.x), \(start.y) -> \(end.x), \(end.y) with existing side \(sideSet[i].start.x), \(sideSet[i].start.y) -> \(sideSet[i].end.x), \(sideSet[i].end.y)")
                            sideSet[i].start = start
                            addedToExistingSide = true
                        } else if sideSet[i].direction == thisDir && sideSet[i].end == start && sideSet[i].inside == insideDir {
                            sideSet[i].end = end
                            addedToExistingSide = true
                        }
                    }
                    
                    if !addedToExistingSide {
                        sideSet.append(Side(start: start, end: end, direction: thisDir, inside: insideDir))
                    }
                }
                
            }
            
            return sideSet
        }
        
        var bulkPrice: Int {
            sides.count * area
        }
    }
    
    var regions: [String: [Region]] = [:]
    
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            let plant = lines[y][x]
            let coord = Coordinate(x: x, y: y)
            
//            print("Looking at \(plant) at \(coord.x),\(coord.y)")
            if regions[plant] == nil {
                regions[plant] = [Region(plant: plant, coordinates: [coord])]
            } else {
                let neighbors = neighbors(coord)
                var addedToExistingRegion = false
                for i in 0..<regions[plant]!.count {
                    
                    if !regions[plant]![i].coordinates.intersection(neighbors).isEmpty {
                        regions[plant]![i].coordinates.insert(coord)
                        addedToExistingRegion = true
                    }
                }
                
                if addedToExistingRegion {
                    var indicesToRemove: [Int] = []
                    for i in 0..<regions[plant]!.count {
                        for j in 0..<i {
                            if !regions[plant]![i].coordinates.intersection(regions[plant]![j].coordinates).isEmpty {
                                regions[plant]![i].coordinates.formUnion(regions[plant]![j].coordinates)
                                indicesToRemove.append(j)
                            }
                        }
                    }
                    for i in indicesToRemove.sorted(by: >) { regions[plant]!.remove(at: i) }
                } else {
                    let newRegion = Region(plant: plant, coordinates: [coord])
                    regions[plant]!.append(newRegion)
                }
            }
        }
    }

    for (plant, regionList) in regions {
        print("*** Plant \(plant) ***")
        for region in regionList {
            //            print("Area=\(region.area), Perim=\(region.perimeter) -- \(region.fenceCoords.count)")
            print("area = \(region.area) - \(region.sides.count) sides")
//            for side in region.sides {
//                print("\(side.start.x),\(side.start.y) -> \(side.end.x),\(side.end.y)")
//            }
            tot += part == 1 ? region.price : region.bulkPrice
        }

    }
    
    print(tot)
    return "\(tot)"
    
    func neighbors(_ coord: Coordinate) -> Set<Coordinate> {
        var neighbors: Set<Coordinate> = []
        
        neighbors.insert(Coordinate(x: coord.x - 1, y: coord.y))
        neighbors.insert(Coordinate(x: coord.x + 1, y: coord.y))
        neighbors.insert(Coordinate(x: coord.x, y: coord.y - 1))
        neighbors.insert(Coordinate(x: coord.x, y: coord.y + 1))
        
        return neighbors
    }

}
