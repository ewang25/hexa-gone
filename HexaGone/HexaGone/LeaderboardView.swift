//
//  LeaderboardView.swift
//  HexaGone
//
//  Created by Avery on 5/4/24.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var data: AppModel
    @Binding var show: Bool
    
    var body: some View {
        if show {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.white)
                        .opacity(0.9)
                    VStack(spacing: 10) {
                        Text("Highscores:")
                            .font(.title)
                        Text("Novice: \(data.noviceHighscore)")
                        Text("Intermediate: \(data.intermediateHighscore)")
                        Text("Advanced: \(data.advancedHighscore)")
                    }
                    VStack {
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
                        Spacer()
                    }
                }.padding(40)
            }
        }
    }
}

//#Preview {
//    LeaderboardView()
//}
