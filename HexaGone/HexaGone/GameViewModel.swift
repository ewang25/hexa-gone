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
        // Temporary value to wait until "first click" to re-initialize
        self.boardMap = boardConfig.mask.map { $0.map { $0 == 0 ? 0 : 7 } }
        // Initialize number of hints left for player to use
        self.hintsLeft = boardConfig.hintCount
        // Initialize tileStates
        resetTileStates()
    }
    
    var boardConfig: BoardConfig
    var boardMap: [[Int8]] = []
    @Published var flagCount = 0
    @Published var tileStates: [[TileState]] = []
    
    // Timer
    @Published var timerActive: Bool = true
    @Published var elapsedTime: Int = 0
    
    // Flag to track first move to initialize board appropriately
    private var firstMove = true
    
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
                        sound_gameWon()
                    }
                }
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
    // Condition for hint or not hint mode
    @Published var hintsLeft: Int
    @Published var hintMode = false
    
    func toggleHintMode() {
        // Activates hint mode if eligable (logic to determine whether eligable)
        if hintMode {
            hintMode = false
            sound_deactivateHintButton()
        } else if (hintsLeft > 0 && !firstMove) {
            // Only activate hint mode when there are still hints left
            // Do not allow use of hint on the first move (it is otherwise wasted because first move is guaranteed (as much as possible) not to be on a mine)
            hintMode = true
            sound_activateHintButton()
        } else {
            sound_noHintsLeft()
        }
    }
    
    // For interactivity
    func handleTap(_ i: Int, _ j: Int) {
        if tileStates[i][j] == .uncovered {
            // Auto-Reveal feature
            // Description: Clicking on hint number with the correct amount of surrounding mines (regardless of whether the flags are correctly placed) will cause all remaining surrounding covered tiles to be revealed.
            ifValidAutoRevealAt(i, j)
            sound_uncoverTileWithZero()
        } else if tileStates[i][j] == .covered {
            // Play sound
            if hintMode {
                sound_useHint()
            } else if boardMap[i][j] == -1 {
                sound_mineClicked()
            } else if boardMap[i][j] == 7 {
                sound_uncoverTileWithZero()
            } else {
                sound_uncoverTile()
            }
            revealAt(i, j)
        } else {
            sound_outOfBoundsTile()
        }
    }
    
    func handleLongPress(_ i: Int, _ j: Int, setFlag: @escaping (Bool) -> Void) {
        setFlag(true)
        
        // play sound
        if tileStates[i][j] == .covered {
            sound_flagTile()
        } else if tileStates[i][j] == .flagged {
            sound_unflagTile()
        }
        
        // perform the long press action immediately
        toggleFlagAt(i, j)
        
        // Reset the flag after a delay, to ensure taps are not processed
        // 0.35 was found to be the best delay on the simulator (for long press minimum duration = 0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            setFlag(false)
        }
    }
    
    
    private func check(_ i: Int, _ j: Int, _ action: (Int, Int) -> Void) {
        checkSurroundingHexagons(map: boardMap, i: i, j: j, action: action)
    }
    
    func revealAt(_ i: Int, _ j: Int) -> Void {
        // Assumes tile state is covered
        // Don't let user reveal (mine) after winning
        if winCon {
            return
        }
        if firstMove {
            revealFirstClick(i, j)
            firstMove = false
        }
        if hintMode {
            // Code to decrease number of hints left and disable hint mode
            hintsLeft -= 1
            hintMode.toggle()
            
            // Flag and return if bomb
            if boardMap[i][j] == -1 {
                toggleFlagAt(i, j)
                return
            }
        }
        if boardMap[i][j] == -1 {
            // Game Over Logic
            loseCon = true // displays Lose modal
            sound_gameLost()
            revealAllTiles()
        }
        revealEmptyTiles(i, j)
    }
    
    func revealFirstClick(_ i: Int, _ j: Int) {
        boardMap = initializeBoard(boardConfig: boardConfig)
        var attempts = 1
        // ten tries to get an empty block
        while (boardMap[i][j] != 7 && attempts < 10) {
            boardMap = initializeBoard(boardConfig: boardConfig)
            attempts += 1
        }
        // ten more tries to get either an empty block or a "one"
        while (boardMap[i][j] != 7 && boardMap[i][j] != 1 && attempts < 20) {
            boardMap = initializeBoard(boardConfig: boardConfig)
            attempts += 1
        }
        // ten more tries to get anything other than a mine
        while (boardMap[i][j] == -1 && attempts < 30) {
            boardMap = initializeBoard(boardConfig: boardConfig)
            attempts += 1
        }
        // regardless of whether attempts are successful, go with the boardMap we have after at most 20 tries.
        
        // Continue to finish revealAt(i, j) logic.
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
    
    func resetTileStates() {
        // Sets all boardMap=0 tiles to .outOfBounds and all others to .covered
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

