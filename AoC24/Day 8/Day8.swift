//
//  Day8.swift
//  AoC24
//
//  Created by Mike Lewis on 12/8/24.
//

import Foundation

func Day8(file: String, part: Int) -> String {
    var tot = 0

    struct Point: Hashable {
        let x: Int
        let y: Int
    }
    
    struct Antenna: Hashable {
        let point: Point
        let freq: String
    }
    
    var antennas: Set<Antenna> = []
    var antinodes: Set<Point> = []
    
    let lines = loadStringsFromFile(file)
    let maxX = lines[0].count
    let maxY = lines.count
    
    for y in 0..<lines.count {
        for x in 0..<lines[y].count {
            let c = lines[y][x]
            
            if c != "." {
                antennas.insert(Antenna(point: Point(x: x, y: y), freq: c))
            }
        }
    }
    
    while antennas.count > 1 {
        let freq = antennas.first!.freq
        let matchingAntennas = Array(antennas.filter { $0.freq == freq })
        print("***")
        print(matchingAntennas)
        antennas.subtract(matchingAntennas)
        
        if matchingAntennas.count > 1 {
            for i in 0..<matchingAntennas.count {
                for j in i+1..<matchingAntennas.count {
                    let xdist = matchingAntennas[i].point.x - matchingAntennas[j].point.x
                    let ydist = matchingAntennas[i].point.y - matchingAntennas[j].point.y
                    var px = matchingAntennas[i].point.x
                    var py = matchingAntennas[i].point.y
                    while (px >= 0 && py >= 0 && px < maxX && py < maxY) {
                        antinodes.insert(Point(x: px, y: py))
                        px += xdist
                        py += ydist
                    }
                    px = matchingAntennas[j].point.x
                    py = matchingAntennas[j].point.y
                    while (px >= 0 && py >= 0 && px < maxX && py < maxY) {
                        antinodes.insert(Point(x: px, y: py))
                        px -= xdist
                        py -= ydist
                    }
                }
            }
        }
    }
    
//    antinodes = antinodes.filter { $0.x >= 0 && $0.y >= 0 && $0.x < lines[0].count && $0.y < lines.count }
    
    
    
    tot = antinodes.count
    print("tot: \(tot)")
    return "\(tot)"
}
