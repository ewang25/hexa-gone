//
//  ContentView.swift
//  HexaGone
//

import SwiftUI

// Prototype Title Screen. Change & style as needed.

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray
                    .ignoresSafeArea(.all)
                VStack {
                    Text("HexaGone Prototype")
                        .font(.title)
                        .padding()
                    NavigationLink(destination: {
                        GameView()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .cornerRadius(10)
                                .frame(width: 200, height: 100)
                            Text("Play")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
