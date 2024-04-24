//
//  HexBoardView.swift
//  HexaGone
//

import SwiftUI

import SwiftUI

struct HexagonView: View {
    @State var currentImage = "tile_1"
    var body: some View {
        Image(currentImage)
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .onTapGesture {
                // reveal number or bomb: change image to tile_3 with number or image_2 with bomb
                print("reveal")
                currentImage = "tile_3"
            }
            .onLongPressGesture {
                // flag: change image to tile_4
                print("long press activated")
                currentImage = "tile_4"
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
