//
//  HexBoardView.swift
//  HexaGone
//

import SwiftUI

import SwiftUI

struct HexagonView: View {
    var body: some View {
        Image("tile_1")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
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
