//
//  GameView.swift
//  HexaGone
//

import SwiftUI

struct GameView: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var zoomScale: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero

    var zoomAndDrag: some Gesture {
        SimultaneousGesture(
            MagnificationGesture()
                .updating($zoomScale) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    self.scale *= value
                },
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    self.offset = CGSize(width: self.offset.width + value.translation.width,
                                         height: self.offset.height + value.translation.height)
                }
        )
    }
    
    var body: some View {
        VStack {
            Text("Zoom and drag the game board")
                .padding()
            
            GeometryReader { geometry in
                self.gameBoard
                    .frame(width: 300, height: 300)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .scaleEffect(scale * zoomScale)
                    .offset(x: offset.width + dragOffset.width, y: offset.height + dragOffset.height)
                    .gesture(self.zoomAndDrag)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var gameBoard: some View {
        Text("Testing Here") // Placeholder for the game board
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
