//
//  HexBoardView.swift
//  HexaGone
//

import SwiftUI

enum TileMode: Int {
    case covered = 1
    case outOfBounds = 2
    case uncovered = 3
    case flagged = 4
}

extension TileMode {
    func imagePath() -> String {
        return "tile_\(self.rawValue)"
    }
}

struct HexagonView: View {
    @State var state : TileMode = .covered
    var isBomb: Bool = false //comment out later - will need to initialize later on
    var body: some View {
        Image(state.imagePath())
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .onTapGesture {
                if (state == .covered) {
                    state = .uncovered
                    // determine number to display
                    if (isBomb == true) {
                        print("game over")
                        //end game
                    } else {
                        print("number of bombs in vicinity")
                        //display number
                    }
                }
                print()
            }
            .onLongPressGesture {
                // long press covered to activate flag
                print("flagged")
                if (state == .covered) {
                    state = .flagged
                }
                // long press flagged to deactivate flag
                else if (state == .flagged) {
                    state = .covered
                }
            }
    }
}

struct HexBoardView: View {
    var cols = 9
    var rows = 9
    let hexSize: CGFloat = 45 // mess around with this

    var body: some View {
        let hexHeight = sqrt(3.0) / 2 * hexSize
        let hexWidth = hexSize
        return GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<cols, id: \.self) { col in
                            HexagonView()
                                .frame(width: hexWidth, height: hexHeight)
                                .offset(x: (row % 2 != 0) ? hexWidth / 2 : 0)
                        }
                    }
                    .offset(y: row % 2 == 0 ? -hexHeight / 4 : -hexHeight / 4)
                }
            }
        }
    }
}

struct HexBoardView_Previews: PreviewProvider {
    static var previews: some View {
        HexBoardView()
    }
}
