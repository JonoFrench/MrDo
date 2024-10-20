//
//  HiScoreView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct HiScoreView: View {
    @EnvironmentObject var manager: GameManager
    
#if os(iOS)
    static var titleTextSize:CGFloat = 24
    static var subTitleTextSize:CGFloat = 12
    static var scoreTextSize:CGFloat = 16
    static var starttextSize:CGFloat = 14
#elseif os(tvOS)
    static var titleTextSize:CGFloat = 28
    static var subTitleTextSize:CGFloat = 18
    static var scoreTextSize:CGFloat = 24
    static var starttextSize:CGFloat = 28
#endif
    var body: some View {
        let scores = manager.hiScores
        VStack {
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("High Scores")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: HiScoreView.titleTextSize))
            Spacer()
            VStack(alignment: .center, content: {
                HStack{
                    Spacer()
                    Text("Name")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Text("Score")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.trailing])
                    Spacer()
                    Text("Level")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.trailing])
                    Spacer()
                    Text("Time")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.trailing])
                    Spacer()
                }
                Spacer()
                ForEach(scores.hiScores, id: \.self) {score in
                    HStack{
                        Spacer()
                        Text("\(score.initials!)")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: HiScoreView.scoreTextSize))
                            .padding([.leading])
                        Spacer()
                        Text("\(String(format: "%05d", score.score))")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: HiScoreView.scoreTextSize))
                            .padding([.trailing])
                        Spacer()
                        Text("\(String(format: "%02d", score.level))")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: HiScoreView.scoreTextSize))
                            .padding([.trailing])
                        Spacer()
                        
                        Text("\((score.time % 3600) / 60)'\(String(format: "%02d",(score.time % 3600) % 60))")
                            .foregroundStyle(.white)
                            .font(.custom("MrDo-Arcade", size: HiScoreView.scoreTextSize))
                            .padding([.trailing])
                        Spacer()
                    }
                    Spacer()
                }
            })
            Spacer()
            Text(GameConstants.startText)
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: HiScoreView.starttextSize))

        }.background(.black)
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return HiScoreView()
        .environmentObject(previewEnvObject)
    
}
