//
//  GameViewModel.swift
//  HexaGone
//

import Foundation

// Note: Key for boardMap: [[Int8]]
// 0 represents an out-of-bounds tile
// -1 is a mine tile
// 1-6 are all hexagon tiles; each number represents however many mines there are around
// 7 is a hexagon tile with no neighboring mines

class GameViewModel: ObservableObject {
    
    init(boardConfig: BoardConfig) {
        self.boardConfig = boardConfig
        reset()
    }
    
    var boardConfig: BoardConfig
    var boardMap: [[Int8]] = []
    @Published var flagCount = 0
    @Published var tileStates: [[TileState]] = []
    
    // Conditions for displaying the win and lose modals
    @Published var winCon = false
    @Published var loseCon = false
    
    func loopCheckWinCon() {
        // Simulate a condition being monitored
        DispatchQueue.global().async {
            while (!self.winCon) {
                if self.checkWin() {
                    // Activate the navigation
                    DispatchQueue.main.async {
                        self.winCon = true
                    }
                }
                Thread.sleep(forTimeInterval: 1)
            }
        }
    }
    
    private func check(_ i: Int, _ j: Int, _ action: (Int, Int) -> Void) {
        checkSurroundingHexagons(map: boardMap, i: i, j: j, action: action)
    }
    
    func revealAt(_ i: Int, _ j: Int) {
        revealEmptyTiles(i, j)
        if boardMap[i][j] == -1 {
            // Game Over Logic
            loseCon = true // displays Lose modal
            revealAllTiles()
        }
    }
    
    func toggleFlagAt(_ i: Int, _ j: Int) {
        if tileStates[i][j] == .covered {
            tileStates[i][j] = .flagged
            countFlags() // update displayed flag count
        } else if (tileStates[i][j] == .flagged && !winCon) {
            // Make it impossible to unflag a flagged tile after winning, this way loseCon cannot be activated simultaneously with winCon.
            tileStates[i][j] = .covered
            countFlags() // update displayed flag count
        }
    }
    
    func countFlags() {
        flagCount = tileStates.flatMap { $0 }.filter { $0 == .flagged }.count
    }
    
    func revealEmptyTiles(_ i: Int, _ j: Int) {
        tileStates[i][j] = .uncovered
        // Recurse (reveal surrounding tiles) if current tile is empty (has hint 0, i.e. boardMap[i][j] = 7
        if boardMap[i][j] == 7 {
            checkSurroundingHexagons(map: boardMap, i: i, j: j, action: { i2, j2 in
                if (tileStates[i2][j2] == .covered && boardMap[i2][j2] > 0) {
                    // The second condition boardMap[i2][j2] > 0 is actually redundant given .covered and boardMap[i][j] = 7
                    // However, we keep it there for good measure.
                    revealEmptyTiles(i2, j2)
                }
            })
        }
    }
    
    func revealAllTiles() {
        for (i, row) in tileStates.enumerated() {
            for (j, value) in row.enumerated() {
                // uncover if part of game board, regardless of current state
                if (value != .outOfBounds) {
                    tileStates[i][j] = .uncovered
                }
            }
        }
    }
    
    // checks win condition
    func checkWin() -> Bool {
        for (i, row) in boardMap.enumerated() {
            for (j, val) in row.enumerated() {
                if (val > 0 && tileStates[i][j] != .uncovered) {
                    return false
                }
                if (val < 0 && tileStates[i][j] == .uncovered) {
                    return false
                }
            }
        }
        return true
    }

    // Count flags for auto-reveal
    func countSurroundingFlags(_ i: Int, _ j: Int) -> Int {
        var count = 0
        check(i, j, { i2, j2 in
            if tileStates[i2][j2] == .flagged {
                count += 1
            }
        })
        return count
    }
    
    func ifValidAutoRevealAt(_ i: Int, _ j: Int) {
        if (boardMap[i][j] != 7 && countSurroundingFlags(i, j) == Int(boardMap[i][j])) {
            check(i, j, {i2, j2 in
                if tileStates[i2][j2] == .covered {
                    revealAt(i2, j2)
                }
            })
        }

    }
    
    func reset() {
        boardMap = initializeBoard(boardConfig: boardConfig)
        
        tileStates = Array(repeating: Array(repeating: TileState.outOfBounds, count: boardConfig.cols), count: boardConfig.rows)
        for (i, row) in boardMap.enumerated() {
            for (j, value) in row.enumerated() {
                if value != 0 {
                    tileStates[i][j] = .covered
                }
            }
        }
    }
}

