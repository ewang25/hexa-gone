//
//  ContentView.swift
//  HexaGone
//

import SwiftUI

// Prototype Title Screen. Change & style as needed.

// Homescreen Idea: Scrolling game baord that gets constantly regenerated (like the accidental updating, but intentional this time)

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                TitleScreenBackgroundView()
                VStack {
                    Text("HexaGone Prototype")
                        .font(.title)
                        .padding()
                    NavigationLink(destination: {GameView(boardConfig: noviceBoard)}) {
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .cornerRadius(10)
                                .frame(width: 200, height: 100)
                            Text("Novice")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                    NavigationLink(destination: {
                        GameView(boardConfig: intermediateBoard)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .cornerRadius(10)
                                .frame(width: 200, height: 100)
                            Text("Intermediate")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                    NavigationLink(destination: {
                        GameView(boardConfig: advancedBoard)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .cornerRadius(10)
                                .frame(width: 200, height: 100)
                            Text("Advanced")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
