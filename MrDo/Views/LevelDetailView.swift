//
//  LevelDetailView.swift
//  MrDo
//
//  Created by Jonathan French on 14.10.24.
//

import SwiftUI

struct LevelDetailView: View {
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
        VStack {
            Spacer()
            ForEach(manager.levelScores.suffix(from: 3), id: \.id) { score in
                HStack {
                    Text("Scene \(score.level)")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Text("\(score.levelScore)")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Text("\((score.time % 3600) / 60)' \((score.time % 3600) % 60)")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: HiScoreView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()

                    
                }
                Spacer()
            }
            
            Text("VERY GOOD !")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: HiScoreView.titleTextSize))
        }
    }
}

#Preview {
    LevelDetailView()
}
