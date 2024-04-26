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

struct SimpleHexagonView: View {
    @Binding var state: TileState
    var isMine: Bool
    var hintNum: Int8 // The number hint that denotes the number of surrounding mines
    
    var body: some View {
        ZStack {
            Image(state.imagePath())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
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

struct HexagonView: View {
    @Binding var state: TileState
    var isMine: Bool
    var hintNum: Int8 // The number hint that denotes the number of surrounding mines
    var revealTile: () -> Void
    var toggleFlag: () -> Void
    var autoRevealCheck: () -> Void
    
    @State private var longPressTriggered = false
    
    private func handleTap() {
        if state == .uncovered {
            // Auto-Reveal feature
            // Description: Clicking on hint number with the correct amount of surrounding mines (regardless of whether the flags are correctly placed) will cause all remaining surrounding covered tiles to be revealed.
            autoRevealCheck()
        } else if state == .covered {
            revealTile()
        }
    }
    
    private func handleLongPress() {
        longPressTriggered = true
        // perform the long press action immediately
        toggleFlag()
        
        // Reset the flag after a delay, to ensure taps are not processed
        // 0.35 was found to be the best delay on the simulator (for long press minimum duration = 0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            longPressTriggered = false
        }
    }
    
    var tapAndLongPressGesture: some Gesture {
            let longPress = LongPressGesture(minimumDuration: 0.3)
                .onEnded { _ in
                    handleLongPress()
                }
            let tap = TapGesture()
                .onEnded {
                    if !longPressTriggered {
                        handleTap()
                    }
                }

            return SimultaneousGesture(tap, longPress)
        }
    
    var body: some View {
        SimpleHexagonView(state: $state, isMine: isMine, hintNum: hintNum).gesture(tapAndLongPressGesture)
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
                            revealTile: { model.revealAt(i, j) },
                            toggleFlag: { model.toggleFlagAt(i, j) },
                            autoRevealCheck: { model.ifValidAutoRevealAt(i, j) }
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
