//
//  AppModel.swift
//  HexaGone
//

import Foundation

// Contains settings and other app-wide environment data, e.g. highscores/leaderboard
class AppModel: ObservableObject {
    @Published var backgroundMusicON = true
    @Published var soundEffectsON = true
    
}
