//
//  ControlsView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    JoyPadView()
                }
                Spacer()
                Spacer()
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.blue,.gray, .white]), center: .center, startRadius: 5, endRadius: 50)
                    )
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .onLongPressGesture(minimumDuration: 0.1){
                        if manager.gameState == .intro {
                            manager.startGame()
                        } else if manager.gameState == .playing {

                        } else if manager.gameState == .highscore {
                            manager.hiScores.nextLetter()
                        }
                    }
                Spacer()
            }
//            
//            Image("ControlBottom")
//                .resizable()
//                .scaledToFill()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: manager.gameScreen.gameSize.width, height: 30)
        }
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return ControlsView()
        .environmentObject(previewEnvObject)
    
}
