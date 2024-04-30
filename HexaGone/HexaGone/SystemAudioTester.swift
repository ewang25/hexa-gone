//
//  SystemAudioTester.swift
//  HexaGone
//

import SwiftUI
import AVKit

// This view is meant for testing system audio options to use for our game
// Find a full list of them here:
// https://github.com/TUNER88/iOSSystemSoundsLibrary
// Record down the sounds that you think could work with the game down below:
//
// ...
//

let soundID : SystemSoundID = 1004

struct SystemAudioTester: View {
    var body: some View {
        Button(action: {
            AudioServicesPlaySystemSound(soundID)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width:200, height:100)
                Text("Play Sound")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SystemAudioTester_Previews: PreviewProvider {
    static var previews: some View {
        SystemAudioTester()
    }
}

