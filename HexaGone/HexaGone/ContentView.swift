//
//  ContentView.swift
//  HexaGone
//

import SwiftUI

// Prototype Title Screen for Review.

struct ContentView: View {
    @StateObject var data = AppModel()
    // create a score system that takes into account difficulty, time, and number of hints used?
    // Should this go in ContentView? Do we need another ViewModel to keep track of score and certain cross-game settings?
    
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
