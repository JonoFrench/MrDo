//
//  LevelDetailView.swift
//  MrDo
//
//  Created by Jonathan French on 14.10.24.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var manager: GameManager
    @ObservedObject var progress: Progress

#if os(iOS)
    static var titleTextSize:CGFloat = 18
    static var subTitleTextSize:CGFloat = 12
    static var scoreTextSize:CGFloat = 16
    static var starttextSize:CGFloat = 14
    static var typeSize = 30.0
#elseif os(tvOS)
    static var titleTextSize:CGFloat = 28
    static var subTitleTextSize:CGFloat = 24
    static var scoreTextSize:CGFloat = 24
    static var starttextSize:CGFloat = 28
    static var typeSize = 60.0
#endif
    var body: some View {
        VStack {
            Spacer()
            ForEach(manager.levelScores.suffix(3), id: \.id) { score in
                HStack {
                    Spacer()
                    Text("Scene \(score.level)")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: ProgressView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Text("\(String(format: "%05d", score.levelScore))")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: ProgressView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Text("\(String(format: "%02d", (score.time % 3600) / 60))'\(String(format: "%02d",(score.time % 3600) % 60))")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: ProgressView.subTitleTextSize))
                        .padding([.leading])
                    Spacer()
                    Image(manager.levelEndImage(type: score.endType))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: ProgressView.typeSize, height: ProgressView.typeSize)
                    Spacer()
                }
            }
            
            Text("VERY GOOD !")
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: ProgressView.titleTextSize))
            
            Spacer()
            ZStack {
                Image(progress.charFrame)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: progress.frameSize.width, height: progress.frameSize.height)
                    .position(progress.charPosition)
                Image(progress.monsterFrame)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: progress.frameSize.width, height: progress.frameSize.height)
                    .position(progress.monsterPosition)
                Image(progress.appleFrame)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: progress.frameSize.width, height: progress.frameSize.height)
                    .position(progress.applePosition)
                Image(progress.doFrame)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: progress.doFrameSize.width, height: progress.doFrameSize.height)
                    .position(progress.doPosition)

                
            }
            Spacer()
        }
    }
}

//#Preview {
//    ProgressView()
//}
