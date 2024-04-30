//
//  TitleScreenView.swift
//  HexaGone
//
//  Created by Purobaburi on 2024-04-30.
//

import SwiftUI

struct TitleScreenButtonConfig: Identifiable {
    var id = UUID()
    var title: String
    var boardConfig: BoardConfig
    var gradient: LinearGradient
}

var TitleScreenButtonList : [TitleScreenButtonConfig] = [
    TitleScreenButtonConfig(title: "Novice", boardConfig: noviceBoard, gradient: LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)),
    TitleScreenButtonConfig(title: "Intermediate", boardConfig: intermediateBoard, gradient: LinearGradient(gradient: Gradient(colors: [.purple, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)),
    TitleScreenButtonConfig(title: "Advanced", boardConfig: advancedBoard, gradient: LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .topLeading, endPoint: .bottomTrailing))
]

struct TitleScreenButton: View {
    var data: TitleScreenButtonConfig

    var body: some View {
        NavigationLink(destination: { GameView(boardConfig: data.boardConfig) }) {
            ZStack {
                HexagonShape()
                    .fill(data.gradient)
                    .frame(width: 200, height: 100)
                    .cornerRadius(10)
                Text(data.title)
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let x = rect.origin.x
        let y = rect.origin.y
        path.move(to: CGPoint(x: x + width * 0.5, y: y))
        path.addLine(to: CGPoint(x: x + width, y: y + height * 0.25))
        path.addLine(to: CGPoint(x: x + width, y: y + height * 0.75))
        path.addLine(to: CGPoint(x: x + width * 0.5, y: y + height))
        path.addLine(to: CGPoint(x: x, y: y + height * 0.75))
        path.addLine(to: CGPoint(x: x, y: y + height * 0.25))
        path.closeSubpath()
        return path
    }
}

struct TitleScreenView: View {
    var body: some View {
        VStack {
            Image("hexagone_graphic")
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .padding()
            ForEach(TitleScreenButtonList) { button in
                TitleScreenButton(data: button)
            }
        }
    }
}

#Preview {
    TitleScreenView()
}
