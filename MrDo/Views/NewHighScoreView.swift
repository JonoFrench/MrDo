//
//  NewHighScoreView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct NewHighScoreView: View {
#if os(iOS)
    static var titleTextSize:CGFloat = 24
    static var subTitleTextSize:CGFloat = 18
    static var letterTextSize:CGFloat = 30
    static var starttextSize:CGFloat = 24
    static var infoTextSize:CGFloat = 12
#elseif os(tvOS)
    static var titleTextSize:CGFloat = 48
    static var subTitleTextSize:CGFloat = 36
    static var letterTextSize:CGFloat = 60
    static var starttextSize:CGFloat = 48
    static var infoTextSize:CGFloat = 24
#endif
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
                .font(.custom("MrDo-Arcade", size: NewHighScoreView.titleTextSize))
            Spacer()
            Text("Enter your initials")
                .foregroundStyle(.white)
                .font(.custom("MrDo-Arcade", size: NewHighScoreView.subTitleTextSize))

            HStack {
                Spacer()
                Text(String(hiScores.letterArray[0]))
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: NewHighScoreView.letterTextSize))
                    .padding()
                    .border(hiScores.letterIndex == 0 ? Color.red : Color.white , width: 2)
                Spacer()
                Text(String(hiScores.letterArray[1]))
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: NewHighScoreView.letterTextSize))
                    .padding()
                    .border(hiScores.letterIndex == 1 ? Color.red : Color.white, width: 2)
                Spacer()
                Text(String(hiScores.letterArray[2]))
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: NewHighScoreView.letterTextSize))
                    .padding()
                    .border(hiScores.letterIndex == 2 ? Color.red : Color.white, width: 2)
                Spacer()
                
            }
            Spacer()
            Text("Press Up / Down")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: NewHighScoreView.infoTextSize))
            Spacer()
            Text("Jump to select")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: NewHighScoreView.infoTextSize))

            Spacer()
        }.background(.black)
    }
}
