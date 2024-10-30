//
//  HiScoreView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct HiScoreView: View {
    @EnvironmentObject var manager: GameManager
    
    var body: some View {
        let scores = manager.hiScores
        VStack {
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("High Scores")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.highScoreTextSize))
            Spacer()
            VStack(alignment: .center, content: {
                HStack{
                    Spacer()
                    Text("Name")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Text("Score")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                        .padding([.trailing])
                    Spacer()
                    Text("Level")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                        .padding([.trailing])
                    Spacer()
                    Text("Time")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                        .padding([.trailing])
                    Spacer()
                }
                Spacer()
                ForEach(scores.hiScores, id: \.self) {score in
                    HStack{
                        Spacer()
                        Text("\(score.initials!)")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: GameConstants.Text.scoreTextSize))
                            .padding([.leading])
                        Spacer()
                        Text("\(String(format: "%05d", score.score))")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: GameConstants.Text.scoreTextSize))
                            .padding([.trailing])
                        Spacer()
                        Text("\(String(format: "%02d", score.level))")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: GameConstants.Text.scoreTextSize))
                            .padding([.trailing])
                        Spacer()
                        
                        Text("\((score.time % 3600) / 60)'\(String(format: "%02d",(score.time % 3600) % 60))")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: GameConstants.Text.scoreTextSize))
                            .padding([.trailing])
                        Spacer()
                    }
                    Spacer()
                }
            })
            Spacer()
            Text(GameConstants.Text.startText)
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))

        }.background(.black)
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return HiScoreView()
        .environmentObject(previewEnvObject)
    
}
