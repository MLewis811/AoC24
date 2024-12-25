//
//  Day21.swift
//  AoC24
//
//  Created by Mike Lewis on 12/23/24.
//

import Foundation

func Day21(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    enum NumPad: Int, CaseIterable {
        case zero = 0
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
        case push = 10
    }
    
    struct numPadMove: Hashable {
        let start: NumPad
        let end: NumPad
    }
    
    enum DirPad: String, CaseIterable {
        case up = "^"
        case right = ">"
        case down = "v"
        case left = "<"
        case push = "A"
    }
    
    struct dirPadMove: Hashable {
        let start: DirPad
        let end: DirPad
    }
    
    let numPadInst = fillNumPadInst()
    var dirPadInst = fillDirPadInst()
    
    pruneDirPadInsts()

    for line in lines {
        let complex = complexity(line)
        print("\(line): \(complex)")
        tot += complex
    }
    
    
    func complexity(_ code: String) -> Int {
        let numVal = Int(String(code[0..<code.count-1]))!
        let firstMove = enterCode(code, currPos: .push)
        var moveCnts = getDirMoveCounts(firstMove[0])
        for _ in 0..<((part == 1) ? 2 : 25) {
            var newCnts: [dirPadMove: Int] = [:]
            for (move, count) in moveCnts {
                if count > 0 {
                    let instCounts = getDirMoveCounts(dirPadInst[move]![0])
                    for (newMove, newCount) in instCounts {
                        newCnts[newMove] = (newCnts[newMove] ?? 0) + (newCount * count)
                    }
                }
            }
            moveCnts = newCnts
        }
        
        var subTotal: Int = 0
        for (move, count) in moveCnts {
//            print("\(move.start.rawValue) \(move.end.rawValue): \(count)")
            subTotal += count
        }
//        print("subTotal: \(subTotal)")
        
        return subTotal * numVal
    }
    
    print("***")
//    subTotal = 0
//    for (move, count) in getDirMoveCounts("<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A") {
//        print("\(move.start.rawValue) \(move.end.rawValue): \(count)")
//        subTotal += count
//    }
//    print("subTotal: \(subTotal)")

    
        
//    for line in lines {
//        let numVal = Int(String(line[0..<line.count-1]))!
//        let possibleDirs = recursiveDirs(line, numRobots: part == 1 ? 3 : 26)
//        let complexity = numVal * possibleDirs[0].count
//        print("\(numVal) * \(possibleDirs[0].count) = \(complexity)")
//        tot += complexity
//    }
    
//    var subTot: Int = 0
//    for (move, count) in getDirMoveCounts("<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A") {
//        subTot += count
//        print("\(move.start.rawValue) -> \(move.end.rawValue): \(count)")
//    }
//    print("subTot: \(subTot)")
//    
//    print(enterCode("029A", currPos: .push))
    
    print(tot)
    return "\(tot)"
    
    func getDirMoveCounts(_ inst: String) -> [dirPadMove: Int] {
        var counts: [dirPadMove: Int] = [:]
        var prevPos: DirPad = .push
        for char in inst {
            let newPos = DirPad(rawValue: String(char))!
            let move = dirPadMove( start: prevPos, end: newPos )
            counts[move] = counts[move] ?? 0
            counts[move]! += 1
            prevPos = newPos
        }
        return counts
    }
    
    func pruneDirPadInsts() {
        for (move, insts) in dirPadInst {
            var shortestInstLen = insts[0].count
            var shortestInst = insts[0]
            if insts.count > 1 {
                for instNum in 1..<insts.count {
                    let nextLvlInsts = enterDirs(insts[instNum], currPos: .push)
                    for nextLvlInst in nextLvlInsts {
                        if nextLvlInst.count < shortestInstLen {
                            shortestInstLen = nextLvlInst.count
                            shortestInst = insts[instNum]
                        }
                    }
                }
            }
            
            dirPadInst[move] = [shortestInst]
        }
    }
    
    func recursiveDirs(_ code: String, numRobots: Int) -> [String] {
        if numRobots == 1 {
            return enterCode(code, currPos: .push)
        }
        
        let possibleDirStrs = recursiveDirs(code, numRobots: numRobots - 1)
        var possibleInsts: [String] = []
        let sortedPossibleDirStrs = possibleDirStrs.sorted(by: { $0.count < $1.count })
        assert(sortedPossibleDirStrs.first!.count == possibleDirStrs.last!.count)
        for possibleDirStr in possibleDirStrs {
            possibleInsts += enterDirs(possibleDirStr, currPos: .push)
        }
        
        var retVal: [String] = []
        var shortestLen = Int.max
        var numSkips = 0
        for possibleInst in possibleInsts {
            if possibleInst.count < shortestLen {
                shortestLen = possibleInst.count
                if retVal.count > 0 {
                    print("Removing \(retVal.count) items")
                    retVal.removeAll()
                }
                retVal.append(possibleInst)
            } else if possibleInst.count == shortestLen {
                retVal.append(possibleInst)
            } else {
                numSkips += 1
//                print("Skipping \(possibleInst)")
            }
        }

        print("\(code), \(numRobots) skipped \(numSkips) items - \(retVal.count) possible")
        return retVal
    }
    
    func enterCode(_ code: String, currPos: NumPad) -> [String] {
//        print("In enterCode with code \(code) and currPos \(currPos)")
        if code.isEmpty {
            return [""]
        }
        
        let digit = String(code.first!)
        
        var retVal: [String] = []
        let nextPos = digit == "A" ? .push : NumPad(rawValue: Int(digit)!)!
        let nextInsts = enterCode(String(code[1...]), currPos: nextPos)
        for i in 0..<numPadInst[numPadMove(start: currPos, end: nextPos)]!.count {
            for j in 0..<nextInsts.count {
                retVal.append(numPadInst[numPadMove(start: currPos, end: nextPos)]![i] + nextInsts[j])
            }
        }
        
//        print( "Returning \(retVal)")
        assert(retVal.count == 1)
        return retVal
    }
    
    func enterDirs(_ dirStr: String, currPos: DirPad) -> [String] {
//        print("In enterDirs with dirStr \(dirStr) and currPos \(currPos)")
        if dirStr.isEmpty {
            return [""]
        }
        
        let firstDir = dirStr[0]
        
        var retVal: [String] = []
        let nextPos = DirPad(rawValue: firstDir)!
        let nextInsts = enterDirs(String(dirStr[1...]), currPos: nextPos)
        for i in 0..<dirPadInst[dirPadMove(start: currPos, end: nextPos)]!.count {
            for j in 0..<nextInsts.count {
                retVal.append(dirPadInst[dirPadMove(start: currPos, end: nextPos)]![i] + nextInsts[j])
            }
        }
        
//        print( "Returning \(retVal)")
        return retVal
    }
    
    func fillDirPadInst() -> [dirPadMove: [String]] {
        var dirPadInst: [dirPadMove: [String]] = [:]
        
        dirPadInst[dirPadMove(start: .up, end: .right)] = ["v>A"]
        dirPadInst[dirPadMove(start: .up, end: .down)] = ["vA"]
        dirPadInst[dirPadMove(start: .up, end: .left)] = ["v<A"]
        dirPadInst[dirPadMove(start: .up, end: .up)] = ["A"]
        dirPadInst[dirPadMove(start: .up, end: .push)] = [">A"]

        dirPadInst[dirPadMove(start: .left, end: .right)] = [">>A"]
        dirPadInst[dirPadMove(start: .left, end: .down)] = [">A"]
        dirPadInst[dirPadMove(start: .left, end: .left)] = ["A"]
        dirPadInst[dirPadMove(start: .left, end: .up)] = [">^A"]
        dirPadInst[dirPadMove(start: .left, end: .push)] = [">>^A"]

        dirPadInst[dirPadMove(start: .down, end: .right)] = [">A"]
        dirPadInst[dirPadMove(start: .down, end: .down)] = ["A"]
        dirPadInst[dirPadMove(start: .down, end: .left)] = ["<A"]
        dirPadInst[dirPadMove(start: .down, end: .up)] = ["^A"]
        dirPadInst[dirPadMove(start: .down, end: .push)] = ["^>A"]

        dirPadInst[dirPadMove(start: .right, end: .right)] = ["A"]
        dirPadInst[dirPadMove(start: .right, end: .down)] = ["<A"]
        dirPadInst[dirPadMove(start: .right, end: .left)] = ["<<A"]
        dirPadInst[dirPadMove(start: .right, end: .up)] = ["<^A"]
        dirPadInst[dirPadMove(start: .right, end: .push)] = ["^A"]
        
        dirPadInst[dirPadMove(start: .push, end: .right)] = ["vA"]
        dirPadInst[dirPadMove(start: .push, end: .down)] = ["<vA"]
        dirPadInst[dirPadMove(start: .push, end: .left)] = ["v<<A"]
        dirPadInst[dirPadMove(start: .push, end: .up)] = ["<A"]
        dirPadInst[dirPadMove(start: .push, end: .push)] = ["A"]
        
        return dirPadInst
    }
    
    func fillNumPadInst() -> [numPadMove: [String]] {
        var numPadInst: [numPadMove: [String]] = [:]
        
        numPadInst[numPadMove(start: .push, end: .zero)] = ["<A"]
        numPadInst[numPadMove(start: .push, end: .one)] = ["^<<A"]
        numPadInst[numPadMove(start: .push, end: .two)] = ["<^A"]
        numPadInst[numPadMove(start: .push, end: .three)] = ["^A"]
        numPadInst[numPadMove(start: .push, end: .four)] = ["^^<<A"]
        numPadInst[numPadMove(start: .push, end: .five)] = ["<^^A"]
        numPadInst[numPadMove(start: .push, end: .six)] = ["^^A"]
        numPadInst[numPadMove(start: .push, end: .seven)] = ["^^^<<A"]
        numPadInst[numPadMove(start: .push, end: .eight)] = ["<^^^A"]
        numPadInst[numPadMove(start: .push, end: .nine)] = ["^^^A"]

        numPadInst[numPadMove(start: .zero, end: .one)] = ["^<A"]
        numPadInst[numPadMove(start: .zero, end: .two)] = ["^A"]
        numPadInst[numPadMove(start: .zero, end: .three)] = ["^>A"]
        numPadInst[numPadMove(start: .zero, end: .four)] = ["^^<A"]
        numPadInst[numPadMove(start: .zero, end: .five)] = ["^^A"]
        numPadInst[numPadMove(start: .zero, end: .six)] = ["^^>A"]
        numPadInst[numPadMove(start: .zero, end: .seven)] = ["^^^<A"]
        numPadInst[numPadMove(start: .zero, end: .eight)] = ["^^^A"]
        numPadInst[numPadMove(start: .zero, end: .nine)] = ["^^^>A"]
        numPadInst[numPadMove(start: .zero, end: .push)] = [">A"]

        numPadInst[numPadMove(start: .one, end: .zero)] = [">vA"]
        numPadInst[numPadMove(start: .one, end: .two)] = [">A"]
        numPadInst[numPadMove(start: .one, end: .three)] = [">>A"]
        numPadInst[numPadMove(start: .one, end: .four)] = ["^A"]
        numPadInst[numPadMove(start: .one, end: .five)] = ["^>A"]
        numPadInst[numPadMove(start: .one, end: .six)] = ["^>>A"]
        numPadInst[numPadMove(start: .one, end: .seven)] = ["^^A"]
        numPadInst[numPadMove(start: .one, end: .eight)] = ["^^>A"]
        numPadInst[numPadMove(start: .one, end: .nine)] = ["^^>>A"]
        numPadInst[numPadMove(start: .one, end: .push)] = [">>vA"]

        numPadInst[numPadMove(start: .two, end: .zero)] = ["vA"]
        numPadInst[numPadMove(start: .two, end: .one)] = ["<A"]
        numPadInst[numPadMove(start: .two, end: .three)] = [">A"]
        numPadInst[numPadMove(start: .two, end: .four)] = ["<^A"]
        numPadInst[numPadMove(start: .two, end: .five)] = ["^A"]
        numPadInst[numPadMove(start: .two, end: .six)] = ["^>A"]
        numPadInst[numPadMove(start: .two, end: .seven)] = ["<^^A"]
        numPadInst[numPadMove(start: .two, end: .eight)] = ["^^A"]
        numPadInst[numPadMove(start: .two, end: .nine)] = ["^^>A"]
        numPadInst[numPadMove(start: .two, end: .push)] = ["v>A"]

        numPadInst[numPadMove(start: .three, end: .zero)] = ["<vA"]
        numPadInst[numPadMove(start: .three, end: .one)] = ["<<A"]
        numPadInst[numPadMove(start: .three, end: .two)] = ["<A"]
        numPadInst[numPadMove(start: .three, end: .four)] = ["<<^A"]
        numPadInst[numPadMove(start: .three, end: .five)] = ["<^A"]
        numPadInst[numPadMove(start: .three, end: .six)] = ["^A"]
        numPadInst[numPadMove(start: .three, end: .seven)] = ["<<^^A"]
        numPadInst[numPadMove(start: .three, end: .eight)] = ["<^^A"]
        numPadInst[numPadMove(start: .three, end: .nine)] = ["^^A"]
        numPadInst[numPadMove(start: .three, end: .push)] = ["vA"]

        numPadInst[numPadMove(start: .four, end: .zero)] = [">vvA"]
        numPadInst[numPadMove(start: .four, end: .one)] = ["vA"]
        numPadInst[numPadMove(start: .four, end: .two)] = ["v>A"]
        numPadInst[numPadMove(start: .four, end: .three)] = ["v>>A"]
        numPadInst[numPadMove(start: .four, end: .five)] = [">A"]
        numPadInst[numPadMove(start: .four, end: .six)] = [">>A"]
        numPadInst[numPadMove(start: .four, end: .seven)] = ["^A"]
        numPadInst[numPadMove(start: .four, end: .eight)] = ["^>A"]
        numPadInst[numPadMove(start: .four, end: .nine)] = ["^>>A"]
        numPadInst[numPadMove(start: .four, end: .push)] = [">>vvA"]

        numPadInst[numPadMove(start: .five, end: .zero)] = ["vvA"]
        numPadInst[numPadMove(start: .five, end: .one)] = ["<vA"]
        numPadInst[numPadMove(start: .five, end: .two)] = ["vA"]
        numPadInst[numPadMove(start: .five, end: .three)] = ["v>A"]
        numPadInst[numPadMove(start: .five, end: .four)] = ["<A"]
        numPadInst[numPadMove(start: .five, end: .six)] = [">A"]
        numPadInst[numPadMove(start: .five, end: .seven)] = ["<^A"]
        numPadInst[numPadMove(start: .five, end: .eight)] = ["^A"]
        numPadInst[numPadMove(start: .five, end: .nine)] = ["^>A"]
        numPadInst[numPadMove(start: .five, end: .push)] = ["vv>A"]

        numPadInst[numPadMove(start: .six, end: .zero)] = ["<vvA"]
        numPadInst[numPadMove(start: .six, end: .one)] = ["<<vA"]
        numPadInst[numPadMove(start: .six, end: .two)] = ["<vA"]
        numPadInst[numPadMove(start: .six, end: .three)] = ["vA"]
        numPadInst[numPadMove(start: .six, end: .four)] = ["<<A"]
        numPadInst[numPadMove(start: .six, end: .five)] = ["<A"]
        numPadInst[numPadMove(start: .six, end: .seven)] = ["<<^A"]
        numPadInst[numPadMove(start: .six, end: .eight)] = ["<^A"]
        numPadInst[numPadMove(start: .six, end: .nine)] = ["^A"]
        numPadInst[numPadMove(start: .six, end: .push)] = ["vvA"]

        numPadInst[numPadMove(start: .seven, end: .zero)] = [">vvvA"]
        numPadInst[numPadMove(start: .seven, end: .one)] = ["vvA"]
        numPadInst[numPadMove(start: .seven, end: .two)] = ["vv>A"]
        numPadInst[numPadMove(start: .seven, end: .three)] = ["vv>>A"]
        numPadInst[numPadMove(start: .seven, end: .four)] = ["vA"]
        numPadInst[numPadMove(start: .seven, end: .five)] = ["v>A"]
        numPadInst[numPadMove(start: .seven, end: .six)] = ["v>>A"]
        numPadInst[numPadMove(start: .seven, end: .eight)] = [">A"]
        numPadInst[numPadMove(start: .seven, end: .nine)] = [">>A"]
        numPadInst[numPadMove(start: .seven, end: .push)] = [">>vvvA"]

        numPadInst[numPadMove(start: .eight, end: .zero)] = ["vvvA"]
        numPadInst[numPadMove(start: .eight, end: .one)] = ["<vvA"]
        numPadInst[numPadMove(start: .eight, end: .two)] = ["vvA"]
        numPadInst[numPadMove(start: .eight, end: .three)] = ["vv>A"]
        numPadInst[numPadMove(start: .eight, end: .four)] = ["<vA"]
        numPadInst[numPadMove(start: .eight, end: .five)] = ["vA"]
        numPadInst[numPadMove(start: .eight, end: .six)] = ["v>A"]
        numPadInst[numPadMove(start: .eight, end: .seven)] = ["<A"]
        numPadInst[numPadMove(start: .eight, end: .nine)] = [">A"]
        numPadInst[numPadMove(start: .eight, end: .push)] = ["vvv>A"]

        numPadInst[numPadMove(start: .nine, end: .zero)] = ["<vvvA"]
        numPadInst[numPadMove(start: .nine, end: .one)] = ["<<vvA"]
        numPadInst[numPadMove(start: .nine, end: .two)] = ["<vvA"]
        numPadInst[numPadMove(start: .nine, end: .three)] = ["vvA"]
        numPadInst[numPadMove(start: .nine, end: .four)] = ["<<vA"]
        numPadInst[numPadMove(start: .nine, end: .five)] = ["<vA"]
        numPadInst[numPadMove(start: .nine, end: .six)] = ["vA"]
        numPadInst[numPadMove(start: .nine, end: .seven)] = ["<<A"]
        numPadInst[numPadMove(start: .nine, end: .eight)] = ["<A"]
        numPadInst[numPadMove(start: .nine, end: .push)] = ["vvvA"]

        for i in NumPad.allCases {
            for j in NumPad.allCases {
                if numPadInst[numPadMove(start: i, end: j)] == nil {
                    if i == j {
                        numPadInst[numPadMove(start: i, end: j)] = ["A"]
                    } else {
                        print("WHY?????????????? \(i) \(j)")
                        let dirsToReverse = numPadInst[numPadMove(start: j, end: i)]!
                        var reversedDirs: [String] = []
                        for dir in dirsToReverse {
                            var reversedDir = ""
                            for i in 0..<dir.count {
                                switch dir[i] {
                                case "^": reversedDir += "v"
                                case "v": reversedDir += "^"
                                case ">": reversedDir += "<"
                                case "<": reversedDir += ">"
                                case "A": reversedDir += "A"
                                default:
                                    break
                                }
                            }
                            reversedDirs.append(reversedDir)
                        }
                        numPadInst[numPadMove(start: i, end: j)] = reversedDirs
                    }
                }
            }
        }
        
        return numPadInst
    }
}
