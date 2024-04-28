//
//  GameView.swift
//  HexaGone
//

import SwiftUI

// TODO: Make it so that (1) onAppear, the game board is centered, (2) include a min and max scale setting (3) include boundaries for the offset settings. This will make sure that the user will not accidentally drag the gameboard off-screen.

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    init(boardConfig: BoardConfig) {
        self._model = StateObject(wrappedValue: GameViewModel(boardConfig: boardConfig))
    }
    
    @StateObject var model: GameViewModel
    @State var timerActive: Bool = true
    
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
                            Image(systemName: "timer.circle")
                                .font(.title)
                            TimerView(isActive: $timerActive)
                        }
                    }
                }
                Spacer()
            }
            // win or lose view on top
            if (model.winCon) {
                Text("win")
                    .padding(20)
                    .background(Color.blue)
            } else if (model.loseCon) {
                Text("lose")
                    .padding(20)
                    .background(Color.red)
            } else {
                Text("you lost the game")
                    .opacity(0) //invisible text if neither win nor loss
            } // I don't think you need this else?
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
            model.loopCheckWinCon()
        }
    }
}

struct TimerView : View {
    
    // TIMER
    @State private var startTime = Date()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var elapsedTime = 0
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
    static var previews: some View {
        GameView(boardConfig: beginnerBoardProto)
    }
}
