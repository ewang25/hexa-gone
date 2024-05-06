//
//  SettingsView.swift
//  HexaGone
//

import SwiftUI

//Structure for an on-off button
struct settingsToggle: View {
    @Binding var flag: Bool
    
    var body: some View {
        Button(action: {
            flag.toggle()
            sound_flagTile()
        }) {
            VStack {
                Text(flag ? "ON" : "OFF")
                    .font(.headline)
                    .foregroundColor(flag ? .green : .red)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(flag ? Color.green : Color.red, lineWidth: 2)
                    )
                    .frame(width: 80, height: 40)
            }
        }
    }
}

//Displaying settings
struct SettingsView: View {
    @EnvironmentObject var data: AppModel
    @Binding var show: Bool
    var inGameView = false
    
    var body: some View {
        if show {
            ZStack(alignment: .top) {
                Color.black.opacity(0.4).ignoresSafeArea()
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.white)
                        .opacity(0.9)
                    VStack(spacing: 30) {
                        Text("Settings")
                            .font(Font.system(size: 42).weight(.bold))
                        HStack {
                            Spacer()
                            Text("Background Music")
                            Spacer()
                            settingsToggle(flag: $data.backgroundMusicON)
                        }
                        HStack {
                            Spacer()
                            Text("Sound Effects")
                            Spacer()
                            settingsToggle(flag: $data.soundEffectsON)
                        }
                        HStack {
                            Spacer()
                            Text("Allow Hints")
                            Spacer()
                            settingsToggle(flag: $data.hintsON)
                        }
                    }.font(Font.system(size: 25)).padding(.top, 50)
                    HStack {
                        Button(action: {
                            show = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                                .padding(10)
                        }
                        Spacer()
                    }
                }.padding(40)
            }
        }
    }
}
