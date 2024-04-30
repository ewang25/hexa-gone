//
//  BGMViewModel.swift
//  HexaGone
//

import Foundation
import AVKit

// Background Music View Model
class BGMViewModel: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    @Published var backgroundMusic: Bool = true {
        didSet {
            updateMusicPlayback()
        }
    }

    init() {
        setupAudioPlayer()
        setupNotifications()
    }

    func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "korobeiniki", withExtension: "mp3") else { return }
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

    @objc func appWillResignActive() {
        audioPlayer?.pause()
    }

    @objc func appDidBecomeActive() {
        if backgroundMusic {
            audioPlayer?.play()
        }
    }

    func updateMusicPlayback() {
        if backgroundMusic {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
