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
// Uncover tile 1103, 1105
// Uncover tile with zero (unlock area)
// Flag tile
// Unflag tile 1050
// Used hint 1033
// Activate hint button
// Deactivate hint button
// No hints left alert
// Click on outOfBounds alert
// Click on main game button sound
// tripped mine/bomb alert
// loss alert 1032?
// win alert
//

func sound_uncoverTile() {
    AudioServicesPlaySystemSound(1104)
}

func sound_uncoverTileWithZero() {
    // for unlocking multiple tiles or auto reveal
    AudioServicesPlaySystemSound(1105)
}

func sound_outOfBoundsTile() {
    // for clicking out of bounds or flagged tile
    AudioServicesPlaySystemSound(1053)
}

func sound_flagTile() {
    AudioServicesPlaySystemSound(1103)
}

func sound_unflagTile() {
    AudioServicesPlaySystemSound(1050)
}

func sound_useHint() {
    AudioServicesPlaySystemSound(1021)
}

func sound_activateHintButton() {
    AudioServicesPlaySystemSound(1111)
}

func sound_deactivateHintButton() {
    AudioServicesPlaySystemSound(1112)
}

func sound_noHintsLeft() {
    AudioServicesPlaySystemSound(1051)
}

func sound_buttonClicked() {
    AudioServicesPlaySystemSound(1030)
}

func sound_mineClicked() {
    AudioServicesPlaySystemSound(1023)
}

func sound_gameWon() {
    AudioServicesPlaySystemSound(1020) // or 1008
}

func sound_gameLost() {
    AudioServicesPlaySystemSound(1024)
}


let soundIDs : [SystemSoundID] = [1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1050, 1051, 1052, 1053, 1054, 1055, 1057, 1070, 1071, 1072, 1073, 1074, 1075, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1150, 1151, 1152, 1153, 1154, 1200, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1254, 1255, 1256, 1257, 1258, 1259, 1300, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313, 1314, 1315, 1320, 1321, 1322, 1323, 1324, 1325, 1326, 1327, 1328, 1329, 1330, 1331, 1332, 1333, 1334, 1335, 1336, 1350, 1351, 4095]

struct SystemAudioTester: View {
    @State var i = 0
    
    var body: some View {
        Button(action: {
            i += 1
            if i == soundIDs.count {
                i = 0
            }
            AudioServicesPlaySystemSound(soundIDs[i])
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width:200, height:100)
                VStack {
                    Text("Play Sound")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("\(soundIDs[i])")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct SystemAudioTester_Previews: PreviewProvider {
    static var previews: some View {
        SystemAudioTester()
    }
}

