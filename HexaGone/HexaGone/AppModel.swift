//
//  AppModel.swift
//  HexaGone
//

import Foundation

// Contains settings and other app-wide environment data, e.g. highscores/leaderboard
class AppModel: ObservableObject {
    
    // Music & Sound Settings
    var bgm = BGMViewModel()
    @Published var backgroundMusicON = true {
        didSet {
            bgm.backgroundMusic = backgroundMusicON
        }
    }
    @Published var soundEffectsON = true
    
    // Highscores
    @Published var noviceHighscore = 0
    @Published var intermediateHighscore = 0
    @Published var advancedHighscore = 0
}
