//
//  Day22.swift
//  AoC24
//
//  Created by Mike Lewis on 12/23/24.
//

import Foundation

func Day22(file: String, part: Int) -> String {
    var tot = 0
    let lines = loadIntsFromFile(file)
    
    let secret = 2024
    
    var nextSecrets: [Int: Int] = [:]
    
    for line in lines {
        let final = getNthSecret(line, 2000)
//        print("\(line): \(final)")
        tot += final
    }
    
//    print(getNthSecret(secret, 2000))
    
    func getNthSecret(_ secret: Int, _ n: Int) -> Int {
        var secret = secret
        for _ in 1...n {
            if nextSecrets[secret] == nil {
                nextSecrets[secret] = nextSecret(secret)
                secret = nextSecrets[secret]!
            } else {
                secret = nextSecrets[secret]!
            }
        }
        return secret
    }
    
    func nextSecret(_ secretInt: Int ) -> Int {
        var secret = intToBinArray(secretInt)
        
        // Step 1
        secret = mix(secret, binArrMultBy64(secret))
        secret = prune(secret)
        
        // Step 2
        secret = mix(secret, binArrDivBy32(secret))
        secret = prune(secret)
        
        // Step 3
        secret = mix(secret, binArrMultBy2048(secret))
        secret = prune(secret)
        
        
        return binArrToInt(secret)
    }
    
    func mix(_ arr1: [Bool], _ arr2: [Bool]) -> [Bool] {
        binArrXor(arr1, arr2)
    }
    
    func prune(_ arr1: [Bool]) -> [Bool] {
        binArrMod16777216(arr1)
    }
    
    func intToBinArray(_ n: Int) -> [Bool] {
        var n = n
        var arr: [Bool] = []
        while n > 0 {
            arr.append(n % 2 == 0 ? false : true)
            n /= 2
        }
        return arr.reversed()
    }
    
    func binArrToInt(_ arr: [Bool]) -> Int {
        let pow = arr.count - 1
        var n: Int = 0
        var val: Int = 1
        for i in 0..<arr.count {
            if arr[pow-i] {
                n += val
            }
            val *= 2
        }
        return n
    }
    
    func binArrMultBy64(_ arr: [Bool]) -> [Bool] {
        arr + [false, false, false, false, false, false]
    }
    
    func binArrDivBy32(_ arr: [Bool]) -> [Bool] {
        if arr.count < 6 { return [false] }
        return Array(arr[0...arr.count-6])
    }
    
    func binArrMultBy2048(_ arr: [Bool]) -> [Bool] {
        arr + [false, false, false, false, false, false, false, false, false, false, false ]
    }
    
    func binArrXor(_ arr1: [Bool], _ arr2: [Bool]) -> [Bool] {
        let longer = arr1.count > arr2.count ? arr1 : arr2
        let shorter = longer == arr2 ? arr1 : arr2
        let diff = longer.count - shorter.count
        var result: [Bool] = Array(longer[0..<(longer.count-shorter.count)])
        for i in 0..<shorter.count {
            result.append(longer[i+diff] != shorter[i])
        }
        return result
    }
    
    func binArrMod16777216(_ arr: [Bool]) -> [Bool] {
        if arr.count < 25 { return arr }
        
        return Array(arr[(arr.count-25+1)...])
    }
    
    print("tot = \(tot)")
    return "\(tot)"
}
