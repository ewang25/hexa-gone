//
//  BGMViewModel.swift
//  HexaGone
//

import Foundation
import AVKit

// Background Music View Model
class BGMViewModel: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    // Variable for whether music is playing
    @Published var backgroundMusic: Bool = true {
        didSet {
            updateMusicPlayback()
        }
    }

    // Initializer
    init() {
        setupAudioPlayer()
        setupNotifications()
    }

    // Sets up Audio Player
    func setupAudioPlayer() {
        // Retrieve Music
        guard let url = Bundle.main.url(forResource: "korobeiniki", withExtension: "mp3") else { return }
        // Create Audio Player, with a catch in case of an error
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.prepareToPlay()
            if backgroundMusic {
                audioPlayer?.play()
            }
        } catch {
            print("Error initializing audio player: \(error)")
        }
    }

    // Ensures that background music does not keep playing when app is exited (but not quitted) by user
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    //method
    @objc func appWillResignActive() {
        audioPlayer?.pause()
    }

    //method
    @objc func appDidBecomeActive() {
        if backgroundMusic {
            audioPlayer?.play()
        }
    }

    //To play or not to play music based on backgroundMusic boolean
    func updateMusicPlayback() {
        if backgroundMusic {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }

    //Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
