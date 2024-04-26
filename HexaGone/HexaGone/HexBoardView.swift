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
    var hintNum: Int8 // The number hint that denotes the number of surrounding mines
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
    @ObservedObject var model: GameViewModel
    
    // constants for scaling/display calculations
    let hexHeight = HEXRATIO * hexSize
    let hexWidth = hexSize

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<model.boardConfig.rows, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0..<model.boardConfig.cols, id: \.self) { j in
                        HexagonView(
                            state: $model.tileStates[i][j],
                            isMine: model.boardMap[i][j] == -1,
                            hintNum: model.boardMap[i][j] == 7 ? 0 : max(model.boardMap[i][j], 0),
                            gameOver: { model.revealAllTiles() },
                            foundEmptyTile: { model.revealEmptyTiles(i, j) },
                            countFlags: model.countFlags // closure
                        )
                        .frame(width: hexWidth, height: hexHeight)
                        .offset(x: (i % 2 != 0) ? hexWidth / 4 : -hexWidth / 4)
                    }
                }
            }
        }
    }
}

struct HexBoardView_Previews: PreviewProvider {
    static var previews: some View {
        HexBoardView(model: GameViewModel(boardConfig: beginnerBoardProto))
    }
}
