//
//  Day23.swift
//  AoC24
//
//  Created by Mike Lewis on 12/31/24.
//

import Foundation

func Day23(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    class Computer: Hashable, Equatable {
        var name: String
        var parents: Set<Computer>

        var grandparents: Set<Computer> {
            var gparents: [Computer] = []
            for parent in parents {
                gparents += parent.parents
            }
            return Set(gparents)
        }
        
        var overlapParsGpars: Set<Computer> {
            var overlapSet = parents.intersection( grandparents )
            overlapSet.insert(self)
            return overlapSet
        }
        
        static func == (lhs: Computer, rhs: Computer) -> Bool {
            lhs.name == rhs.name
        }
        
        init(name: String, parents: Set<Computer> = []) {
            self.name = name
            self.parents = parents
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }
    
    class Edge: Hashable, Equatable {
        let comps: Set<Computer>
        
        static func == (lhs: Edge, rhs: Edge) -> Bool {
            lhs.comps == rhs.comps
        }
        
        init(comps: Set<Computer>) {
            self.comps = comps
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(comps)
        }
    }
    
    
    var computers: Set<Computer> = []
    var edges: Set<Edge> = []
    
    for line in lines {
        let comps = line.split(separator: "-").map { String($0) }
        if computers.contains(where: { $0.name == comps[0] }) {
            let comp = computers.first(where: { $0.name == comps[0] })!
            if computers.contains(where: { $0.name == comps[1] }) {
                let newComp = computers.first(where: { $0.name == comps[1] })!
                comp.parents.insert(newComp)
                newComp.parents.insert(comp)
                edges.insert(Edge(comps: [comp, newComp]))
            } else {
                let newComp = Computer( name: comps[1], parents: [comp] )
                computers.insert(newComp)
                comp.parents.insert(newComp)
                edges.insert(Edge(comps: [comp, newComp]))
            }
        } else {
            let comp = Computer( name: comps[0], parents: [] )
            computers.insert(comp)
            if computers.contains(where: { $0.name == comps[1] }) {
                let newComp = computers.first(where: { $0.name == comps[1] })!
                comp.parents.insert(newComp)
                newComp.parents.insert(comp)
                edges.insert(Edge(comps: [comp, newComp]))
            } else {
                let newComp = Computer( name: comps[1], parents: [comp] )
                computers.insert(newComp)
                comp.parents.insert(newComp)
                edges.insert(Edge(comps: [comp, newComp]))
            }
        }
    }
    
    for edge in edges.filter( { $0.comps.contains(Computer(name: "co"))} ) {
        print("\(edge.comps.map( { $0.name } ).sorted(by: {$0 < $1}))")
    }
    
    var setsOfThree: Set<Set<Computer>> = []
    var biggestSet: Set<Computer> = []
    for comp in computers.sorted(by: { $0.name < $1.name }) {
//        var overlapParsGpars = comp.overlapParsGpars
        let pars = comp.parents
//        if part == 2 {
////            let grandpars = comp.grandparents
////            print("\(comp.name) -> \(pars.map( {$0.name} ).sorted(by: {$0 < $1})) -> \(grandpars.map( {$0.name} ).sorted(by: {$0 < $1})) -> \(comp.overlapParsGpars.map( {$0.name} ).sorted(by: {$0 < $1}))")
//        } else {
            for parent in pars {
                for grandparent in parent.parents {
                    if pars.contains(grandparent) {
                        let newSetOfThree = Set([comp, parent, grandparent])
                        if !setsOfThree.contains(newSetOfThree) {
                            print("\(comp.name) -> \(parent.name) -> \(grandparent.name)")
                            setsOfThree.insert(newSetOfThree)
                        }
                    }
                }
            }
//        }
//        if part == 2 {
//            if overlapParsGpars.count > biggestSet.count {
//                biggestSet = overlapParsGpars
//            }
//        }
    }
    
    tot = (part == 1) ? setsOfThree.filter( { $0.contains(where: { $0.name.hasPrefix("t") }) } ).count : 0
    
    if part == 2 {
        print("HERE!!")
        var biggerSets = setsOfThree
        var prevSetsOfThree: Set<Set<Computer>> = []
        while biggerSets.isEmpty == false {
            
            var newBiggerSets: Set<Set<Computer>> = []
            for set in biggerSets {
                let comps = set.sorted(by: { $0.name < $1.name })
                var inCommon = comps[0].parents
                for i in 1..<comps.count {
                    inCommon = inCommon.intersection(comps[i].parents)
                }
                
                for setofThree in setsOfThree {
                    if setofThree.isSubset(of: inCommon) {
                        newBiggerSets.insert(setofThree.union(set))
                    }
                }
            }
            
            for set in newBiggerSets {
                print(set.map( { $0.name } ).sorted(by: { $0 < $1 }))
            }
            print(newBiggerSets.count)
            prevSetsOfThree = biggerSets
            biggerSets = newBiggerSets
            
        }
        print("DONE stepping up by 3!!")
        biggerSets = prevSetsOfThree
        
        while biggerSets.isEmpty == false {
            
            var newBiggerSets: Set<Set<Computer>> = []
            for set in biggerSets {
                let comps = set.sorted(by: { $0.name < $1.name })
                var inCommon = comps[0].parents
                for i in 1..<comps.count {
                    inCommon = inCommon.intersection(comps[i].parents)
                }
                
                if !inCommon.isEmpty {
                    for commonParent in inCommon {
                        var setToInsert = set
                        setToInsert.insert(commonParent)
                        newBiggerSets.insert(setToInsert)
                    }
                }
                
            }
            
            for set in newBiggerSets {
                print(set.map( { $0.name } ).sorted(by: { $0 < $1 }))
            }
            print(newBiggerSets.count)
            prevSetsOfThree = biggerSets
            biggerSets = newBiggerSets
            
        }
        
    }

    print(tot)
    return "\(tot)"
}
