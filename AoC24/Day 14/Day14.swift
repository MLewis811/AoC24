//
//  Day14.swift
//  AoC24
//
//  Created by Mike Lewis on 12/13/24.
//

import Foundation

func Day14Part2(file: String, part: Int, t: Int) -> [Bool] {
    let lines = loadStringsFromFile(file)
    struct Loc: Hashable {
        let x: Int
        let y: Int
    }
    
    struct Robot {
        let startPos: (x: Int, y: Int)
        let vel: (x: Int, y: Int)
        
        func currPos(t: Int, mapSize: (x: Int, y: Int)) -> (x: Int, y: Int) {
            let currX = (startPos.x + t * vel.x) %% mapSize.x
            let currY = (startPos.y + t * vel.y) %% mapSize.y
            
            return (currX, currY)
        }
    }

    var robots: [Robot] = []
    
    for line in lines {
        let posPart = line.split(separator: " ")[0]
        let velPart = line.split(separator: " ")[1]
        
        let posCoords = posPart[2...].split(separator: ",").map { Int($0)! }
        let velComps = velPart[2...].split(separator: ",").map { Int($0)! }

        robots.append( Robot( startPos: (posCoords[0], posCoords[1]), vel: (velComps[0], velComps[1]) ) )
    }
    
    let mapSize = (x: 101, y: 103)
    
    var retArray: [[Bool]] = []
    
    var currLoc: Set<Loc> = []
    
    for robot in robots {
        let (x, y) = robot.currPos(t: t, mapSize: mapSize)
        currLoc.insert(Loc(x: x, y: y))
    }
    
    for y in 0..<mapSize.y {
        var outArray: [Bool] = []
        for x in 0..<mapSize.x {
            outArray.append(currLoc.contains(Loc(x: x, y: y)))
        }
        retArray.append(outArray)
    }
    
    var finalArray: [Bool] = []
    
    for array in retArray {
        finalArray += array
    }
    
    return finalArray
}

func Day14(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    struct Loc: Hashable {
        let x: Int
        let y: Int
    }
    
    struct Robot {
        let startPos: (x: Int, y: Int)
        let vel: (x: Int, y: Int)
        
        func currPos(t: Int, mapSize: (x: Int, y: Int)) -> (x: Int, y: Int) {
            let currX = (startPos.x + t * vel.x) %% mapSize.x
            let currY = (startPos.y + t * vel.y) %% mapSize.y
            
            return (currX, currY)
        }
    }

    var robots: [Robot] = []
    
    for line in lines {
        let posPart = line.split(separator: " ")[0]
        let velPart = line.split(separator: " ")[1]
        
        let posCoords = posPart[2...].split(separator: ",").map { Int($0)! }
        let velComps = velPart[2...].split(separator: ",").map { Int($0)! }

        robots.append( Robot( startPos: (posCoords[0], posCoords[1]), vel: (velComps[0], velComps[1]) ) )
    }
    
    let mapSize = (x: 101, y: 103)
    
    if part == 1 {
        var currLocs: [Loc] = []
        var quadrantCnts = [0,0,0,0]
        
        for robot in robots {
            let (x,y) = robot.currPos(t: 100, mapSize: mapSize)
            currLocs.append(Loc(x: x, y: y))
        }
        
        for loc in currLocs.sorted( by: { ($0.y, $0.x) < ($1.y, $1.x) } ) {
            var quadNum = -1
            if loc.y < mapSize.y / 2 {
                if loc.x < mapSize.x / 2 {
                    quadNum = 0
                } else if loc.x > mapSize.x / 2 {
                    quadNum = 1
                }
            } else if loc.y > mapSize.y / 2 {
                if loc.x < mapSize.x / 2 {
                    quadNum = 2
                } else if loc.x > mapSize.x / 2 {
                    quadNum = 3
                }
            }
            //        print("(\(loc.x),\(loc.y)): quad \(quadNum)")
            if quadNum != -1 {
                quadrantCnts[quadNum] += 1
            }
        }
        
        tot = 1
        for quadrantCnt in quadrantCnts {
            tot *= quadrantCnt
        }
        print(tot)
    } else {
        
        
        var t = 0
        
        var currLoc: Set<Loc> = []
        
        for robot in robots {
            let (x, y) = robot.currPos(t: t, mapSize: mapSize)
            currLoc.insert(Loc(x: x, y: y))
        }
        
        for y in 0..<mapSize.y {
            var outStr = ""
            for x in 0..<mapSize.x {
                outStr += (currLoc.contains(Loc(x: x, y: y))) ? "X" : " "
            }
            print(outStr)
        }
        
    }
    
    func Day14Part2(file: String, part: Int) -> [[Bool]] {
        
        var t = 0
        
        var retArray: [[Bool]] = []
        
        var currLoc: Set<Loc> = []
        
        for robot in robots {
            let (x, y) = robot.currPos(t: t, mapSize: mapSize)
            currLoc.insert(Loc(x: x, y: y))
        }
        
        for y in 0..<mapSize.y {
            var outArray: [Bool] = []
            for x in 0..<mapSize.x {
                outArray.append(currLoc.contains(Loc(x: x, y: y)))
            }
            retArray.append(outArray)
        }
        
        return retArray
    }
    
    return "\(tot)"
}
