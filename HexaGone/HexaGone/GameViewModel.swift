//
//  GameViewModel.swift
//  HexaGone
//

import Foundation

class GameViewModel: ObservableObject {
    
    init(boardConfig: BoardConfig) {
        self.boardConfig = boardConfig
        reset()
    }
    
    var boardConfig: BoardConfig
    var boardMap: [[Int8]] = []
    @Published var flagCount = 0
    @Published var tileStates: [[TileState]] = []
    
    func countFlags() {
        flagCount = tileStates.flatMap { $0 }.filter { $0 == .flagged }.count
    }
    
    func revealEmptyTiles(_ i: Int, _ j: Int) {
        checkSurroundingHexagons(map: boardMap, i: i, j: j, action: { i2, j2 in
            if (tileStates[i2][j2] == .covered && boardMap[i2][j2] > 0) {
                tileStates[i2][j2] = .uncovered
                
                // recurse if current tile is also empty
                if (boardMap[i2][j2] == 7) {
                    revealEmptyTiles(i2, j2)
                }
            }
        })
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
    
    //checks if you lost
    func checkLose() -> Bool {
        for (i, row) in boardMap.enumerated() {
            for (j, val) in row.enumerated() {
                if (val < 0 && tileStates[i][j] == .uncovered) {
                    return true
                }
            }
        }
        return false
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

