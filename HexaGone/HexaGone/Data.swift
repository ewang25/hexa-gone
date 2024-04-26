//
//  Data.swift
//  HexaGone
// for all logic

import Foundation

let hexSize: CGFloat = 90 // Temporary (delete this later)
let HEXRATIO: CGFloat = sqrt(3.0)/2

// for masks, every second row (%2==1) is shifted towards the right.

struct BoardConfig {
    var rows: Int
    var cols: Int
    var mineCount: Int
    var mask: [[Int8]]
    
    // helpers for ZoomAndDragView
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

//prototype and visualization of a Beginner board
let beginnerBoardProto = BoardConfig(rows: 11+8, cols: 11+6, mineCount: 10, mask: [
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

// 0 represents an out-of-bounds tile
// -1 is a mine tile
// 1-6 are all hexagon tiles; each number represents however many mines there are around
// 7 is a hexagon tile with no neighboring mines



//let beginnerBoard = boardConfig(rows: 11+8, cols: 11+6, mineCount: 10, mask: generateBoard(n: 6))


//function for padding the board based on size of map(n) with padding(k)
func boardPadding(n: Int, k: Int) -> Int {
    return 2 * n - 1 + 2 * k
}


//test the board
let advancedBoard = BoardConfig(rows: boardPadding(n: 17, k: 4), cols: boardPadding(n: 17, k: 3), mineCount: 110, mask: generateBoard(n: 17, h: 3, v: 4))

let intermediateBoard = BoardConfig(rows: boardPadding(n: 11, k: 4), cols: boardPadding(n: 11, k: 3), mineCount: 65, mask: generateBoard(n: 11, h: 3, v: 4))

let noviceBoard = BoardConfig(rows: boardPadding(n: 5, k: 4), cols: boardPadding(n: 5, k: 3), mineCount: 10, mask: generateBoard(n: 5, h: 3, v: 4))



//function to generate a board given the size of the map(n) with horizontal bounds(h) and vertical bounds(v)
func generateBoard(n: Int, h: Int, v: Int) -> [[Int8]] {
    //size of board (extra 3 cells on left/right, extra 4 on top/bottom)
    var newboard = Array(repeating: Array(repeating: Int8(0), count: boardPadding(n: n, k: h)), count: boardPadding(n: n, k: v))
     
    //function to determine number of zeros on left of row
    func leftMargin(extraMargin: Int) -> Int {
        h + extraMargin
    }

    //function for number of zeros in right of row
    func rightMargin(extraMargin: Int) -> Int {
        newboard[0].count - 1 - h - extraMargin
    }
    
    //iterate over rows
    for i in v...(newboard.count - 1 - v){
        
        let totalExtraMargin = abs(i-(n+3))
        
        if ((n + i) % 2 == 1){
            for j in leftMargin(extraMargin: totalExtraMargin/2)...rightMargin(extraMargin: totalExtraMargin/2) {
                newboard[i][j] = 1
            }
        }
        else {
            if (n % 2 == 0) {
                for j in leftMargin(extraMargin: (totalExtraMargin+1)/2)...rightMargin(extraMargin: (totalExtraMargin-1)/2) {
                    newboard[i][j] = 1
                }
            }
            else {
                for j in leftMargin(extraMargin: (totalExtraMargin-1)/2)...rightMargin(extraMargin: (totalExtraMargin+1)/2) {
                    newboard[i][j] = 1
                }
            }
        }
    }
    return newboard
}


func initializeBoard(boardConfig: BoardConfig) -> [[Int8]] {
    // Create a deep copy of the mask
    var array: [[Int8]] = boardConfig.mask.map { $0.map { $0 } }
    
    // Randomly place the mines
    // Collect all the positions of the '1's
    var positionsOfOnes: [(Int, Int)] = []
    for (i, row) in array.enumerated() {
        for (j, value) in row.enumerated() {
            if value == 1 {
                positionsOfOnes.append((i, j))
            }
        }
    }
    
    // Randomly select N positions if N is less than the total number of '1's (available tiles)
    // where N is
    let numberToKeep = min(boardConfig.mineCount, positionsOfOnes.count)
    let selectedPositions = positionsOfOnes.shuffled().prefix(numberToKeep)
    
    // And turn these randomly selected positions into mines
    for (i, j) in selectedPositions {
        array[i][j] = -1
    }
    
    // Then change the remaining 1s to reflect hint numbers
    // Helper function:
    func countSurroundingMines(i: Int, j: Int) -> Int8 {
        var count: Int8 = 0
        checkSurroundingHexagons(map: array, i: i, j: j, action: { i, j in
            if (array[i][j] == -1) {
                count += 1
            }
        })
        return count
    }
    // Replace remaining 1s with appropriate number hints.
    for (i, row) in array.enumerated() {
        for (j, value) in row.enumerated() {
            if value == 1 {
                let hint = countSurroundingMines(i: i, j: j)
                array[i][j] = hint == 0 ? 7 : hint
            }
        }
    }
    
    return array
}

func checkSurroundingHexagons(map: [[Int8]], i: Int, j: Int, action: (Int, Int) -> Void) {
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
