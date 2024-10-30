//
//  Progress10View.swift
//  MrDo
//
//  Created by Jonathan French on 17.10.24.
//

import SwiftUI

struct Progress10View: View {
    @EnvironmentObject var manager: GameManager

    var body: some View {
        ZStack(alignment: .center) {
            let score = manager.levelScores.last
            let averageTime = manager.gameTime / manager.screenData.level
            let averageScore = manager.score / manager.screenData.level
            ScreenView(gameScreen: manager.screenData)
                .zIndex(0.5)
                .overlay(alignment: .top, content: {
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                    #if os(tvOS)
                        Spacer()
                        Spacer()
                        Spacer()
                    #endif
                        HStack(spacing: 0) {
                            Text("Scene \(score!.level) ")
                                .foregroundStyle(.cyan)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                                .padding([.leading])
                            Spacer()
                            Text("\(String(format: "%05d", score!.levelScore))")
                                .foregroundStyle(.cyan)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                            Spacer()
                            Text("\(String(format: "%02d", (score!.time % 3600) / 60))'\(String(format: "%02d",(score!.time % 3600) % 60))")
                                .foregroundStyle(.cyan)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                            Image("Cherry")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: GameConstants.Size.typeSize, height: GameConstants.Size.typeSize)
                                .padding([.trailing])
                        }.zIndex(2.0).background(.black)
                        Spacer()
                        HStack(spacing: 0) {
                            Text("TOTAL  ")
                                .foregroundStyle(.red)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                                .padding([.leading])
                            Spacer()
                            Text("\(String(format: "%05d", manager.score))")
                                .foregroundStyle(.red)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                            Spacer()
                            Text("\((score!.time % 3600) / 60)'\((score!.time % 3600) % 60)")
                                .foregroundStyle(.red)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                            Image("Blank")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: GameConstants.Size.typeSize, height: GameConstants.Size.typeSize)
                                .padding([.trailing])
                        }.background(.black)
                        Spacer()
                        HStack(spacing: 0) {
                            Text("AVERAGE")
                                .foregroundStyle(.green)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                                .padding([.leading])
                            Spacer()
                            Text("\(String(format: "%05d", averageScore ))")
                                .foregroundStyle(.green)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                            Spacer()
                            Text("\((averageTime % 3600) / 60)'\((averageTime % 3600) % 60)")
                                .foregroundStyle(.green)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                            Image("Blank")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: GameConstants.Size.typeSize, height: GameConstants.Size.typeSize)
                                .padding([.trailing])
                        }.background(.black)
                    }.frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
                        .overlay(alignment:.center, content: {
                            VStack(alignment: .center, spacing: 10) {
                                
                                Text("WONDERFUL !")
                                    .foregroundStyle(.yellow)
                                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.subTitleTextSize))
                                    .offset(GameConstants.Size.wonderSize)
                            }
                        })
                })
        }
    }
}

#Preview {
    Progress10View()
}
