//
//  Data.swift
//  HexaGone
// for all logic

import Foundation

let hexSize: CGFloat = 90 // Temporary (delete this later)

// for masks, every second row (%2==1) is shifted towards the right.

struct boardConfig {
    var rows: Int
    var cols: Int
    var mask: [[Bool]]
    
    func boardWidth() -> CGFloat {
        return hexSize * (CGFloat(cols) + 1.5) // the +1.5 accounts for the alignment/shift factor
    }
    func boardHeight() -> CGFloat {
        return sqrt(3.0) / 2 * hexSize * CGFloat(rows)
    }
}

let beginnerBoard = boardConfig(rows: 11+8, cols: 11+4, mask: [
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 5)+Array(repeating: true, count: 6)+Array(repeating: false, count: 4),
    Array(repeating: false, count: 4)+Array(repeating: true, count: 7)+Array(repeating: false, count: 4),
    Array(repeating: false, count: 4)+Array(repeating: true, count: 8)+Array(repeating: false, count: 3),
    Array(repeating: false, count: 3)+Array(repeating: true, count: 9)+Array(repeating: false, count: 3),
    Array(repeating: false, count: 3)+Array(repeating: true, count: 10)+Array(repeating: false, count: 2),
    Array(repeating: false, count: 2)+Array(repeating: true, count: 11)+Array(repeating: false, count: 2),
    Array(repeating: false, count: 3)+Array(repeating: true, count: 10)+Array(repeating: false, count: 2),
    Array(repeating: false, count: 3)+Array(repeating: true, count: 9)+Array(repeating: false, count: 3),
    Array(repeating: false, count: 4)+Array(repeating: true, count: 8)+Array(repeating: false, count: 3),
    Array(repeating: false, count: 4)+Array(repeating: true, count: 7)+Array(repeating: false, count: 4),
    Array(repeating: false, count: 5)+Array(repeating: true, count: 6)+Array(repeating: false, count: 4),
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 15),
    Array(repeating: false, count: 15)
])


