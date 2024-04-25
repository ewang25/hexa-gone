//
//  HexBoardView.swift
//  HexaGone
//

import SwiftUI

enum TileState: Int {
    case covered = 1
    case outOfBounds = 2
    case uncovered = 3
    case flagged = 4
}

extension TileState {
    func imagePath() -> String {
        return "tile_\(self.rawValue)"
    }
}

struct HexagonView: View {
    @Binding var state: TileState
    var isMine: Bool
    var hintNum: UInt8 // The number hint that denotes the number of surrounding mines
    var gameOver: () -> Void
    var foundEmptyTile: () -> Void
    var countFlags: () -> Void
    
    var body: some View {
        ZStack {
            Image(state.imagePath())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .onTapGesture {
                    if (state == .covered) {
                        state = .uncovered
                        // determine number to display
                        if (isMine) {
                            gameOver()
                        } else if (hintNum == 0) {
                            foundEmptyTile()
                        }
                    }
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            // long press covered to activate flag
                            if (state == .covered) {
                                state = .flagged
                                countFlags()
                            }
                            // long press flagged to deactivate flag
                            else if (state == .flagged) {
                                state = .covered
                                countFlags()
                            }
                        }
                )
            
            if (state == .uncovered) {
                if (isMine) {
                    Image("mine")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } else {
                    if (hintNum != 0) {
                        Image("num_\(hintNum)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }
            }
        }
    }
}

struct HexBoardView: View {
    init(board: boardConfig, flagCount: Binding<Int>) {
        self._flagCount = flagCount // Connect binding variables manually
        self.board = board
        self.mines = randomlyPlace(in: board.mask, n: board.mineCount)
        self.hints = getNumberHints(map: board.mask, mines: self.mines)
        
        self.states = Array(repeating: Array(repeating: TileState.outOfBounds, count: board.mask[0].count), count: board.mask.count)
    }
    
    var board: boardConfig
    @Binding var flagCount: Int
    var mines: [[UInt8]]
    var hints: [[UInt8]]
    @State var states: [[TileState]]
    
    func revealEmptyTiles(i: Int, j: Int) {
        checkSurroundingHexagons(map: board.mask, i: i, j: j, action: { i2, j2 in
            if (states[i2][j2] == .covered && mines[i2][j2] == 0) {
                states[i2][j2] = .uncovered
                if (hints[i2][j2] == 0) {
                    revealEmptyTiles(i: i2, j: j2)
                }
            }
        })
    }
    
    func revealAllTiles() {
        for (i, row) in states.enumerated() {
            for (j, value) in row.enumerated() {
                if (value != .outOfBounds) {
                    states[i][j] = .uncovered
                }
            }
        }
    }
    
    func countFlags() {
        flagCount = states.flatMap { $0 }.filter { $0 == .flagged }.count
    }

    var body: some View {
        let hexHeight = HEXRATIO * hexSize
        let hexWidth = hexSize
        return VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<board.rows, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0..<board.cols, id: \.self) { j in
                        HexagonView(
                            state: $states[i][j],
                            isMine: mines[i][j] != 0,
                            hintNum: hints[i][j],
                            gameOver: { print("game over"); revealAllTiles() },
                            foundEmptyTile: { revealEmptyTiles(i: i, j: j) },
                            countFlags: countFlags
                        )
                        .frame(width: hexWidth, height: hexHeight)
                        .offset(x: (i % 2 != 0) ? hexWidth / 4 : -hexWidth / 4)
                    }
                }
            }
        }.onAppear() {
            for (i, row) in board.mask.enumerated() {
                for (j, value) in row.enumerated() {
                    if value == 1 {
                        self.states[i][j] = TileState.covered
                    }
                }
            }
        }
    }
}

struct HexBoardView_Previews: PreviewProvider {
    static var previews: some View {
        HexBoardView(board: beginnerBoard, flagCount: Binding<Int>(
            get: { return 5 },       // Start with a dummy value
            set: { _ in }            // Do nothing on change
        ))
    }
}
