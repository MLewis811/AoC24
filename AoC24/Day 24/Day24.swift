//
//  Day24.swift
//  AoC24
//
//  Created by Mike Lewis on 12/25/24.
//

import Foundation

func Day24(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadStringsFromFile(file)
    
    class Wire: Hashable, Equatable, Comparable {
        let name: String
        var value: Bool?
        var parents: [Wire]
        var parentFun: String
        var children: [Wire]
        
        var pfunc: Bool? {
            switch parentFun {
            case "XOR": return xor(parents[0], parents[1])
            case "AND": return and(parents[0], parents[1])
            case "OR": return or(parents[0], parents[1])
            default: return nil
            }
        }
        
        private func xor(_ w1: Wire, _ w2: Wire) -> Bool? {
            guard w1.value != nil && w2.value != nil else { return nil }
            return w1.value != w2.value
        }
        
        private func and(_ w1: Wire, _ w2: Wire) -> Bool? {
            guard w1.value != nil && w2.value != nil else { return nil }
            return w1.value! && w2.value!
        }
        
        private func or(_ w1: Wire, _ w2: Wire) -> Bool? {
            guard w1.value != nil && w2.value != nil else { return nil }
            return w1.value! || w2.value!
        }
        
        
        init(name: String, value: Bool? = nil, parents: [Wire] = [], children: [Wire] = [], parentFun: String = "") {
            self.name = name
            self.value = value
            self.parents = parents
            self.children = children
            self.parentFun = parentFun
        }
        
        static func == (lhs: Wire, rhs: Wire) -> Bool {
            lhs.name == rhs.name
        }
        
        static func < (lhs: Wire, rhs: Wire) -> Bool {
            lhs.name < rhs.name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }
    
    var wires: Set<Wire> = []
    for line in lines {
        if line.contains( ": " ) {
            let split = line.split(separator: ": ")
            let wireName = String(split[0])
            let value = (split[1] == "1")
            wires.insert(Wire(name: wireName, value: value))
        } else if !line.isEmpty {
            print(line)
            let split = line.split(separator: " -> ")
            let childName = String(split[1])
            let parentInfo = split[0].split(separator: " ").map { String($0) }
            if let parent1 = wires.first(where: { $0.name == parentInfo[0] }) {
                if let parent2 = wires.first(where: { $0.name == parentInfo[2] }) {
                    if let childWire = wires.first(where: { $0.name == childName }) {
                        print("UPDATING \(childName)")
                        childWire.parents = [parent1, parent2]
                        childWire.parentFun = parentInfo[1]
                    } else {
                        print("inserting \(childName)")
                        wires.insert(Wire(name: childName, parents: [parent1, parent2], parentFun: parentInfo[1]))
                    }
                } else {
                    print("P1 exists but P2 does not - inserting P2")
                    let parent2 = Wire(name: parentInfo[2])
                    wires.insert(parent2)
                    if let childWire = wires.first(where: { $0.name == childName }) {
                        print("UPDATING \(childName)")
                        childWire.parents = [parent1, parent2]
                        childWire.parentFun = parentInfo[1]
                    } else {
                        print("inserting \(childName)")
                        wires.insert(Wire(name: childName, parents: [parent1, parent2], parentFun: parentInfo[1]))
                    }
                }
            } else {
                if let parent2 = wires.first(where: { $0.name == parentInfo[2] }) {
                    print("P1 does not exist but P2 exists - inserting P1")
                    let parent1 = Wire(name: parentInfo[0])
                    wires.insert(parent1)
                    if let childWire = wires.first(where: { $0.name == childName }) {
                        print("UPDATING \(childName)")
                        childWire.parents = [parent1, parent2]
                        childWire.parentFun = parentInfo[1]
                    } else {
                        print("inserting \(childName)")
                        wires.insert(Wire(name: childName, parents: [parent1, parent2], parentFun: parentInfo[1]))
                    }
                } else {
                    print("Neither P1 nor P2 exists - inserting P1 & P2")
                    let parent1 = Wire(name: parentInfo[0])
                    wires.insert(parent1)
                    let parent2 = Wire(name: parentInfo[2])
                    wires.insert(parent2)
                    if let childWire = wires.first(where: { $0.name == childName }) {
                        print("UPDATING \(childName)")
                        childWire.parents = [parent1, parent2]
                        childWire.parentFun = parentInfo[1]
                    } else {
                        print("inserting \(childName)")
                        wires.insert(Wire(name: childName, parents: [parent1, parent2], parentFun: parentInfo[1]))
                    }
                }
            }
        }
    }
    print("**********")
    
    var passNum = 1
    var unsetZs: Set<Wire> = wires.filter { $0.name.hasPrefix("z") && $0.value == nil }
    while !unsetZs.isEmpty {
        for wire in wires {
            if wire.value == nil {
                wire.value = wire.pfunc
                if wire.value != nil {
                    print("\(wire.name): \(wire.value == nil ? "not set" : "\(wire.value!)") - \(wire.parents.map({ $0.name })) - \(wire.parentFun): \(wire.pfunc)")
                }
            }
            if wire.value != nil && unsetZs.contains(wire) {
                unsetZs.remove(wire)
            }
        }
        print("Pass \(passNum): \(unsetZs.count) unset zs remaining")
        passNum += 1
    }
    
    var powOfTwo: Int = 1
    tot = 0
    for wire in wires.filter( { $0.name.hasPrefix("z") } ).sorted(by: { $0.name < $1.name }) {
        let amtToAdd = powOfTwo * (wire.value! ? 1 : 0)
        print("\(wire.name): \(wire.value == nil ? "not set" : "\(wire.value!)") - adding \(amtToAdd)")
        tot += amtToAdd
        powOfTwo *= 2
    }


    print(tot)
    return "\(tot)"
}
