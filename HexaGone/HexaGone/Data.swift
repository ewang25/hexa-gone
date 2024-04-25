//
//  Data.swift
//  HexaGone
// for all logic

import Foundation

let hexSize: CGFloat = 90 // Temporary (delete this later)
let HEXRATIO: CGFloat = sqrt(3.0)/2

// for masks, every second row (%2==1) is shifted towards the right.

struct boardConfig {
    var rows: Int
    var cols: Int
    var mineCount: Int
    var mask: [[UInt8]]
    
    func boardWidth() -> CGFloat {
        return hexSize * (CGFloat(cols) + 1.5) // the +1.5 accounts for the alignment/shift factor
    }
    func boardHeight() -> CGFloat {
        return sqrt(3.0) / 2 * hexSize * CGFloat(rows)
    }
}

//let beginnerBoard = boardConfig(rows: 11+8, cols: 11+4, mask: [
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 5)+Array(repeating: true, count: 6)+Array(repeating: false, count: 4),
//    Array(repeating: false, count: 4)+Array(repeating: true, count: 7)+Array(repeating: false, count: 4),
//    Array(repeating: false, count: 4)+Array(repeating: true, count: 8)+Array(repeating: false, count: 3),
//    Array(repeating: false, count: 3)+Array(repeating: true, count: 9)+Array(repeating: false, count: 3),
//    Array(repeating: false, count: 3)+Array(repeating: true, count: 10)+Array(repeating: false, count: 2),
//    Array(repeating: false, count: 2)+Array(repeating: true, count: 11)+Array(repeating: false, count: 2),
//    Array(repeating: false, count: 3)+Array(repeating: true, count: 10)+Array(repeating: false, count: 2),
//    Array(repeating: false, count: 3)+Array(repeating: true, count: 9)+Array(repeating: false, count: 3),
//    Array(repeating: false, count: 4)+Array(repeating: true, count: 8)+Array(repeating: false, count: 3),
//    Array(repeating: false, count: 4)+Array(repeating: true, count: 7)+Array(repeating: false, count: 4),
//    Array(repeating: false, count: 5)+Array(repeating: true, count: 6)+Array(repeating: false, count: 4),
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 15),
//    Array(repeating: false, count: 15)
//])

let beginnerBoard = boardConfig(rows: 11+8, cols: 11+6, mineCount: 10, mask: [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
     [0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0],
    [0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
     [0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0],
    [0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
     [0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
    [0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
     [0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0],
    [0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
     [0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0],
    [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
])



func generateBoard(n: Int) -> [[UInt8]] {
    var newboard = Array(repeating: Array(repeating: UInt8(0), count: 6 + 2 * n - 1), count: 8 + 2 * n - 1)
    
    
    
    return newboard
}



func randomlyPlace(in array: [[UInt8]], n: Int) -> [[UInt8]] {
    // Collect all the positions of the '1's
    var positionsOfOnes: [(Int, Int)] = []
    for (i, row) in array.enumerated() {
        for (j, value) in row.enumerated() {
            if value == 1 {
                positionsOfOnes.append((i, j))
            }
        }
    }
    
    // Randomly select 'n' positions if 'n' is less than the total number of '1's
    let numberToKeep = min(n, positionsOfOnes.count)
    let selectedPositions = positionsOfOnes.shuffled().prefix(numberToKeep)
    
    // Create a new 2D array filled with '0's
    var newArray = Array(repeating: Array(repeating: UInt8(0), count: array[0].count), count: array.count)
    
    // Place '1's in the randomly selected positions
    for (i, j) in selectedPositions {
        newArray[i][j] = 1
    }
    
    return newArray
}

func checkSurroundingHexagons(map: [[UInt8]], i: Int, j: Int, action: (Int, Int) -> Void) {
    // Useful definitions
    let i_max = map.count - 1
    let j_max = map[0].count - 1
    
    if (j != 0) {
        action(i, j-1)
    }
    if (j != j_max) {
        action(i, j+1)
    }
    // note that "eveness/oddness" were defined based off the one-indexed diagram, whereas this is zero indexed.
    if (i % 2 == 0) {
        // "odd" rows are shifted to the left
        if (i != 0) {
            action(i-1, j)
            if (j != 0) {
                action(i-1, j-1)
            }
        }
        if (i != i_max) {
            action(i+1, j)
            if (j != 0) {
                action(i+1, j-1)
            }
        }
    } else {
        // "even" rows are shifted to the right
        if (i != 0) {
            action(i-1, j)
            if (j != j_max) {
                action(i-1, j+1)
            }
        }
        if (i != i_max) {
            action(i+1, j)
            if (j != j_max) {
                action(i+1, j+1)
            }
        }
    }
}

func getNumberHints(map: [[UInt8]], mines: [[UInt8]]) -> [[UInt8]] {
    
    func countSurroundingMines(i: Int, j: Int) -> UInt8 {
        var count: UInt8 = 0
        checkSurroundingHexagons(map: map, i: i, j: j, action: { i, j in count += mines[i][j] })
        return count
    }
    
    var newArray = Array(repeating: Array(repeating: UInt8(0), count: map[0].count), count: map.count)
    for (i, row) in map.enumerated() {
        for (j, value) in row.enumerated() {
            // Only bother counting those tiles which are not mines themselves.
            if (value != 0 && mines[i][j] == 0) {
                // count surrounding mines
                newArray[i][j] = countSurroundingMines(i: i, j: j)
            }
        }
    }
    
    return newArray
}

struct GameModel {
    
    init(board: boardConfig) {
        self.board = board
        self.mines = randomlyPlace(in: board.mask, n: board.mineCount)
        self.hints = getNumberHints(map: board.mask, mines: self.mines)
    }
    
    var board: boardConfig
    var mines: [[UInt8]]
    var hints: [[UInt8]]
}


