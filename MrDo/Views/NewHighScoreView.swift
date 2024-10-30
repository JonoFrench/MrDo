//
//  NewHighScoreView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct NewHighScoreView: View {

    @ObservedObject var hiScores:MrDoHighScores
    var body: some View {
        VStack {
            Spacer()
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text("New High Score")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.highScoreTextSize))
            Spacer()
            Text("Enter your initials")
                .foregroundStyle(.white)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.titleTextSize))

            HStack {
                Spacer()
                Text(String(hiScores.letterArray[0]))
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.letterTextSize))
                    .padding()
                    .border(hiScores.letterIndex == 0 ? Color.red : Color.white , width: 2)
                Spacer()
                Text(String(hiScores.letterArray[1]))
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.letterTextSize))
                    .padding()
                    .border(hiScores.letterIndex == 1 ? Color.red : Color.white, width: 2)
                Spacer()
                Text(String(hiScores.letterArray[2]))
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.letterTextSize))
                    .padding()
                    .border(hiScores.letterIndex == 2 ? Color.red : Color.white, width: 2)
                Spacer()
                
            }
            Spacer()
            Text("Press Up / Down")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.copyTextSize))
            Spacer()
            Text("Jump to select")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.copyTextSize))

            Spacer()
        }.background(.black)
    }
}
