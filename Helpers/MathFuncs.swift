//
//  MathFuncs.swift
//  AoC23
//
//  Created by Mike Lewis on 12/8/23.
//

import Foundation

// Greatest Common Denominator of Two #s
func gcd(_ a: Int, _ b: Int) -> Int {
    if a == 0 {
        return b
    }
    if b == 0 {
        return a
    }
    
    let x = max(a,b)
    let y = min(a,b)
    
    return gcd(y, (x % y))
}

// Least Common Multiple of Two #s
func lcm(_ a: Int, _ b: Int) -> Int {
    return (a * b) / gcd(a,b)
}

// Least Common Multiple of an Array of #s
func lcmm(_ nums: [Int] ) -> Int {
    if nums.count == 2 {
        return lcm(nums[0], nums[1])
    }
    
    let a = nums[0]
    let newNums = Array(nums[1...])
    return lcm(a,lcmm(newNums))
}
