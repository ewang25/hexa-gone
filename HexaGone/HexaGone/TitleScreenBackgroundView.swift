//
//  TitleScreenBackgroundView.swift
//  HexaGone
//

import SwiftUI

struct TitleScreenBackgroundView: View {
    // Size of the base frame (this applies to "content")
    public var frameWidth: CGFloat = titleScreenBackgroundBoard.boardWidth()
    public var frameHeight: CGFloat = titleScreenBackgroundBoard.boardHeight()

    @State private var offset: CGSize = .zero
    @State private var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var flipflop = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GeometryReader { geometry in
                TitleScreenBackgroundHexBoardView(flipflop: $flipflop)
                    .frame(width: frameWidth, height: frameHeight)
                    .clipShape(Rectangle())
                    .offset(x: offset.width, y: offset.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .onReceive(timer) { _ in
            // Additional actions to refresh the content
            flipflop.toggle()
            performStep()
        }
    }
    
    @State var step = 0
    
    func performStep() {
        if (flipflop) {
            withAnimation(Animation.easeInOut(duration: 5)) {
                offset = CGSize(width: -90, height: -90)
            }
        } else {
            withAnimation(Animation.easeInOut(duration: 5)) {
                offset = CGSize(width: 90, height: 90)
            }
        }
    }
}

let titleScreenBackgroundBoard = BoardConfig(rows: 20, cols: 20, mineCount: 75, mask: Array(repeating: Array(repeating: Int8(1), count: 20), count: 20))

struct TitleScreenBackgroundHexBoardView: View {
    @StateObject var model = GameViewModel(boardConfig: titleScreenBackgroundBoard)
    
    // constants for scaling/display calculations
    let hexHeight = HEXRATIO * hexSize
    let hexWidth = hexSize
    
    @Binding var flipflop: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<model.boardConfig.rows, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0..<model.boardConfig.cols, id: \.self) { j in
                        SimpleHexagonView(
                            state: $model.tileStates[i][j],
                            isMine: model.boardMap[i][j] == -1,
                            hintNum: model.boardMap[i][j] == 7 ? 0 : max(model.boardMap[i][j], 0)
                        )
                        .frame(width: hexWidth, height: hexHeight)
                        .offset(x: (i % 2 != 0) ? hexWidth / 4 : -hexWidth / 4)
                    }
                }
            }
        }.onAppear() {
            model.boardMap = initializeBoard(boardConfig: model.boardConfig)
            model.tileStates = Array(repeating: Array(repeating: TileState.uncovered, count: model.boardConfig.cols), count: model.boardConfig.rows)
        }
        .onChange(of: flipflop) { _ in
            model.boardMap = initializeBoard(boardConfig: model.boardConfig)
        }
    }
}

#Preview {
    TitleScreenBackgroundView()
}
