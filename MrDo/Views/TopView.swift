//
//  TopView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var manager: GameManager
#if os(iOS)
    static var topTextSize:CGFloat = 14
    static var extraTextSize:CGFloat = 22
    static var extraInsideTextSize:CGFloat = 18
    static var liveSize = CGSize(width: 28, height: 28)
#elseif os(tvOS)
    static var topTextSize:CGFloat = 28
    static var extraTextSize:CGFloat = 44
    static var extraInsideTextSize:CGFloat = 40
    static var liveSize = CGSize(width: 48, height: 48)
#endif
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack {
                Text("1ST")
                    .foregroundStyle(.green)
                    .font(.custom("MrDo-Arcade", size: TopView.topTextSize))
                    .padding([.trailing])
                Text("\(String(format: "%06d", manager.score))")
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: TopView.topTextSize))
                    .padding([.trailing])
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            VStack(alignment: .center) {
                Rectangle()
                    .stroke(.yellow,lineWidth: 3)
                    .background(.black)
                    .overlay(
                        HStack {
                            Text("E")
                                .foregroundStyle(manager.extraCollected[0] ? .yellow : .gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(1)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 0 && !manager.extraAppearing && manager.gameState == .playing ? manager.extraFrames[0] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("X")
                                .foregroundStyle(manager.extraCollected[1] ? .yellow : .gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 1 && !manager.extraAppearing && manager.gameState == .playing ? manager.extraFrames[1] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("T")
                                .foregroundStyle(manager.extraCollected[2] ? .yellow : .gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 2 && !manager.extraAppearing && manager.gameState == .playing ? manager.extraFrames[2] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("R")
                                .foregroundStyle(manager.extraCollected[3] ? .yellow : .gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 3 && !manager.extraAppearing && manager.gameState == .playing ? manager.extraFrames[3] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("A")
                                .foregroundStyle(manager.extraCollected[4] ? .yellow : .gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 4 && !manager.extraAppearing && manager.gameState == .playing ? manager.extraFrames[4] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                        }.padding(4)
                    )
            }.frame(width: manager.screenData.assetDimension * 4)
                .opacity(manager.extraLifeFlashOn ? 1.0 : 0.0)
            VStack {
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
}
