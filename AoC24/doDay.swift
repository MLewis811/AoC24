//
//  doDay.swift
//  AoC22
//
//  Created by Mike Lewis on 12/1/22.
//

import Foundation

func doDay(day: Int, file: String, part: Int) -> String {
    
    let dayFile = "day" + (String(day)) + file
    switch day {
    case 1:
        return Day1(file: dayFile, part: part)
    case 2:
        return Day2(file: dayFile, part: part)
    case 3:
        return Day3(file: dayFile, part: part)
    case 4:
        return Day4(file: dayFile, part: part)
//    case 5:
//        return Day5Part2(file: dayFile, part: part)
//    case 6:
//        return Day6(file: dayFile, part: part)
//    case 7:
//        return Day7(file: dayFile, part: part)
//    case 8:
//        return Day8(file: dayFile, part: part)
//    case 9:
//        return Day9(file: dayFile, part: part)
//    case 10:
//        return Day10(file: dayFile, part: part)
//    case 11:
//        return Day11(file: dayFile, part: part)
//    case 12:
//        return Day12(file: dayFile, part: part)
//    case 13:
//        return Day13(file: dayFile, part: part)
//    case 14:
//        return Day14(file: dayFile, part: part)
//    case 15:
//        return Day15(file: dayFile, part: part)
//    case 16:
//        return Day16(file: dayFile, part: part)
//    case 17:
//        return Day17(file: dayFile, part: part)
//    case 18:
//        return Day18(file: dayFile, part: part)
//    case 19:
//        return Day19(file: dayFile, part: part)
//    case 20:
//        return Day20(file: dayFile, part: part)
//    case 21:
//        return Day21(file: dayFile, part: part)
//    case 22:
//        return Day22(file: dayFile, part: part)
//    case 23:
//        return Day23(file: dayFile, part: part)
//    case 24:
//        return Day24(file: dayFile, part: part)
//    case 25:
//        return Day25(file: dayFile, part: part)
    default:
        return ""
    }
}
