//
//  LeaderboardView.swift
//  HexaGone
//

import SwiftUI

//Display leaderboard
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
                    VStack(spacing: 70) {
                        Text("High Scores")
                            .font(Font.system(size: 42).weight(.bold))
                        Text("Novice: \(data.noviceHighscore)")
                            .font(Font.system(size: 30))
                        Text("Intermediate: \(data.intermediateHighscore)")
                            .font(Font.system(size: 30))
                        Text("Advanced: \(data.advancedHighscore)")
                            .font(Font.system(size: 30))
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
