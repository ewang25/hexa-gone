//
//  GameView.swift
//  HexaGone
//

import SwiftUI

// TODO: Make it so that (1) onAppear, the game board is centered, (2) include a min and max scale setting (3) include boundaries for the offset settings. This will make sure that the user will not accidentally drag the gameboard off-screen.

struct winModal: View {
    @StateObject var model: GameViewModel
    var score: Int
    var elapsedTime: Int
    var hintsLeft: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.green)
                .opacity(0.5)
            VStack {
                Spacer()
                Text("You Win!")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(Color.white)
                Spacer()
                Text("Score: \(Int(score))")
                    .font(.system(size: 25))
                    .bold()
                    .foregroundColor(Color.white)
                Text("Time Elapsed: \(Int(elapsedTime))")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color.white)
                Text("Hints Left: \(Int(hintsLeft))")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color.white)
                Spacer()
                //reset button
                Button(action: {
                    model.factoryReset()
                }) {
                    Text("Play Again")
                        .font(.system(size:25))
                        .bold()
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.95, green: 0.95, blue: 0.95), Color(red: 0.2, green: 0.2, blue: 0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
        }.frame(width: 200, height: 300)
    }
}

struct winModel_Previews: PreviewProvider {
    @StateObject static var data = AppModel()
    static var previews: some View {
        winModal(model: GameViewModel(boardConfig: beginnerBoardProto), score: 0, elapsedTime: 0, hintsLeft: 0)
    }
}

struct loseModal: View {
    @StateObject var model: GameViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.red)
                .opacity(0.5)
            VStack {
                Spacer()
                Text("You Lost!")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(Color.white)
                Spacer()
                //reset button
                Button(action: {
                    model.factoryReset()
                }) {
                    Text("Try Again")
                        .font(.system(size:25))
                        .bold()
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.95, green: 0.95, blue: 0.95), Color(red: 0.2, green: 0.2, blue: 0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
        }.frame(width: 200, height: 300)
    }
}

struct loseModel_Previews: PreviewProvider {
    @StateObject static var data = AppModel()
    static var previews: some View {
        loseModal(model: GameViewModel(boardConfig: beginnerBoardProto))
    }
}

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    init(boardConfig: BoardConfig) {
        self._model = StateObject(wrappedValue: GameViewModel(boardConfig: boardConfig))
    }
    
    @StateObject var model: GameViewModel
    @EnvironmentObject var data: AppModel
    @State var score = 0
    
    func updateHighScore() {
        // have different score systems for different board (different constants to account for difficulty)
        score = model.getScore()
        // updating highscores when the game ends (for each board)
        if (model.boardConfig.id == noviceBoard.id && score > data.noviceHighscore && model.winCon) {
            data.noviceHighscore = score
        } else if (model.boardConfig.id == intermediateBoard.id && score > data.intermediateHighscore && model.winCon) {
            data.intermediateHighscore = score
        } else if (model.boardConfig.id == advancedBoard.id && score > data.advancedHighscore && model.winCon) {
            data.advancedHighscore = score
        }
    }
    
    @State var scoreHintsLeftAdditive: Double = 0.0
    @State var scoreFlagsUsedAdditive: Double = 0.0
    @State var scoreAdditive: Double = 0.0
    
    var body: some View {
        ZStack {
            ZoomAndDragView(
                frameWidth: model.boardConfig.boardWidth(),
                frameHeight: model.boardConfig.boardHeight(),
                content: HexBoardView(
                    model: model
                )
            )
            VStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(10)
                            .frame(width: 140, height: 90)
                            .padding()
                        VStack (spacing: 5) {
                            HStack {
                                // live mine count/flag usage in game
                                Text("Mines:")
                                    .bold()
                                Image("flag")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            Text("\(model.flagCount)/\(model.boardConfig.mineCount)")
                                .font(.title)
                        }
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(10)
                            .frame(width: 140, height: 90)
                            .padding()
                        VStack (spacing: 0) {
                            // timer at top right in game
                            Image(systemName: "timer.circle")
                                .font(.title)
                            TimerView(startTime: $model.startTime, elapsedTime: $model.elapsedTime, isActive: $model.timerActive)
                        }
                    }
                }
                Spacer()
                HStack {
                    // hints button that toggles whether or not you're in hintMode, and updates visually to account for number of hints left.
                    // Also disables button when data.hintsON = false
                    if (data.hintsON) {
                        Button(action: {
                            model.toggleHintMode()
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(
                                        model.hintMode ? .gray : .white
                                    )
                                    .cornerRadius(10)
                                    .frame(width: 90, height: 90)
                                    .padding()
                                VStack (spacing: 0) {
                                    Image(systemName:
                                            model.hintsLeft > 0 ?
                                          "lightbulb.fill" : "lightbulb"
                                    )
                                    .font(.title)
                                    Text("\(model.hintsLeft)")
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            // win or lose (modal) view on top
            if (model.winCon) {
                winModal(model:model, score: score, elapsedTime: model.elapsedTime, hintsLeft: model.hintsLeft)
            } else if (model.loseCon) {
                loseModal(model: model)
            } else {
                Text("you lost the game")
                    .opacity(0) // invisible text if neither win nor loss
            }
        }
        // Custom back button
        .navigationBarBackButtonHidden(true)
        .toolbar  {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(5)
                            .frame(width: 45, height: 45)
                        Image(systemName: "arrow.left.circle")
                    }
                }
            }
        }
        .onAppear{
            sound_uncoverTile()
            model.loopCheckWinCon(action: updateHighScore)
            DispatchQueue.global().async {
                while(true) {
                    while (model.timerActive) {
                        // check what type of board the game is using the boardConfig id variable
                        if (model.boardConfig.id == noviceBoard.id) {
                            // score is based on difficulty, number of hints used, and number of flags used
                            scoreHintsLeftAdditive = Double(10 * (3 - model.hintsLeft))
                            scoreFlagsUsedAdditive = Double(1 * Double(model.flagCount))
                            scoreAdditive = Double(Double(model.elapsedTime) + scoreHintsLeftAdditive + scoreFlagsUsedAdditive)
                            score = Int(100000*2 / (scoreAdditive))
                        }
                        if (model.boardConfig.id == intermediateBoard.id) {
                            scoreHintsLeftAdditive = Double(10 * (4 - model.hintsLeft))
                            scoreFlagsUsedAdditive = Double(0.5 * Double(model.flagCount))
                            scoreAdditive = Double(Double(model.elapsedTime) + scoreHintsLeftAdditive + scoreFlagsUsedAdditive)
                            score = Int(500000*2 / (scoreAdditive))
                        }
                        if (model.boardConfig.id == advancedBoard.id) {
                            scoreHintsLeftAdditive = Double(10 * (4 - model.hintsLeft))
                            scoreFlagsUsedAdditive = Double(0.25 * Double(model.flagCount))
                            scoreAdditive = Double(Double(model.elapsedTime) + scoreHintsLeftAdditive + scoreFlagsUsedAdditive)
                            score = Int(2500000*2 / (scoreAdditive))
                        }
                        // have different score systems for different board (different constants to account for difficulty)
                        if (model.loseCon || model.winCon) {
                            // updating highscores when the game ends (for each board)
                            if (model.boardConfig.id == noviceBoard.id && score > data.noviceHighscore && model.winCon) {
                                data.noviceHighscore = score
                            }
                            if (model.boardConfig.id == intermediateBoard.id && score > data.intermediateHighscore && model.winCon) {
                                data.intermediateHighscore = score
                            }
                            if (model.boardConfig.id == advancedBoard.id && score > data.advancedHighscore && model.winCon) {
                                data.advancedHighscore = score
                            }
                            DispatchQueue.main.async {
                                model.timerActive = false
                            }
                        }
                        Thread.sleep(forTimeInterval: 0.5)
                    }
                }
            }
        }
    }
}

struct TimerView : View {
    
    // TIMER
    @Binding var startTime: Date
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var elapsedTime: Int
    @Binding var isActive: Bool
    
    // Computes the elapsed time string
    var elapsedTimeString: String {
        let totalSeconds = elapsedTime
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Updates the elapsed time based on the current date and the start time
    func updateElapsedTime() {
        elapsedTime = Int(Date().timeIntervalSince(startTime))
    }
    
    // Clean up the timer when the view disappears
    func cleanupTimer() {
        timer.upstream.connect().cancel()
    }
    
    func reset() {
        startTime = Date()
        elapsedTime = 0
    }
    
    var body: some View {
        Text("\(elapsedTimeString)")
            .onReceive(timer) { _ in
                if isActive {
                    updateElapsedTime()
                }
            }
            .onAppear {
                startTime = Date()  // Reset the start time when the view appears
            }
    }
}

struct GameView_Previews: PreviewProvider {
    @StateObject static var data = AppModel()
    static var previews: some View {
        GameView(boardConfig: beginnerBoardProto).environmentObject(data)
    }
}
