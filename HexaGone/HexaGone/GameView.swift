//
//  GameView.swift
//  HexaGone
//

import SwiftUI

// TODO: Make it so that (1) onAppear, the game board is centered, (2) include a min and max scale setting (3) include boundaries for the offset settings. This will make sure that the user will not accidentally drag the gameboard off-screen.

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    let board = beginnerBoard
    var body: some View {
        VStack {
            ZoomAndDragView(frameWidth: board.boardWidth(), frameHeight: board.boardHeight(), content: HexBoardView(board: beginnerBoard))
        }
        // Custom back button.
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(5)
                            .frame(width: 45, height: 45)
                        Image(systemName: "arrow.left.circle")
                    }
                }
            }
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
