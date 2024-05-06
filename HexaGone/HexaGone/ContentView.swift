//
//  ContentView.swift
//  HexaGone
//

import SwiftUI

struct ContentView: View {
    // Contains settings and other app-wide environment data, e.g. highscores/leaderboard
    @StateObject var data = AppModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                TitleScreenBackgroundView()
                TitleScreenView()
            }
        }.environmentObject(data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
