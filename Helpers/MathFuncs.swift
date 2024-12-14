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

// Modulo operator that always returns a positive #
infix operator %%
extension Int {
    static  func %% (_ left: Int, _ right: Int) -> Int {
        if left >= 0 { return left % right }
        if left >= -right { return (left+right) }
        return ((left % right)+right)%right
    }
}

// Extended Greatest Common Divisor (Extended Euclidean Algorithm)
func extendedGCD(_ a: Int, _ b: Int) -> (x: Int, y: Int) {
    if b == 0 {
        return (1, 0)
    }
    
    let (x1, y1) = extendedGCD(b, a % b)
    let x = y1
    let y = x1 - y1 * (a / b)
    
    return (x,y)
}
