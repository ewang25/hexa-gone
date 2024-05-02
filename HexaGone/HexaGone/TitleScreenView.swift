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
    @State var showSettingsModal = false
    @EnvironmentObject var data: AppModel
    
    var body: some View {
        ZStack {
            VStack {
                Image("hexagone_graphic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding()
                ForEach(TitleScreenButtonList) { button in
                    TitleScreenButton(data: button)
                }
                HStack {
                    NavigationLink(destination: {Text("Highscore: \(data.highscore)")}) {
                        ZStack {
                            VStack {
                                Image(systemName: "trophy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.95, blue: 0.43), Color(red: 0.96, green: 0.65, blue: 0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 0, leading: 90, bottom: 0, trailing: 0))
                    }
                    Spacer()
                    Button(action: {
                        if !showSettingsModal {
                            showSettingsModal = true
                        }
                    }) {
                        ZStack {
                            VStack {
                                Image(systemName: "gear")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.95, green: 0.95, blue: 0.95), Color(red: 0.2, green: 0.2, blue: 0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 95))
                    }
                }
            }
            SettingsView(show: $showSettingsModal)
        }
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
    }
}

