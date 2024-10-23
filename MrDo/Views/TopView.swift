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
                        HStack(spacing: 2) {
                            Text("E")
                                .foregroundStyle(.gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(1)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 0 ? manager.extraFrames[0] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("X")
                                .foregroundStyle(.gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 1 ? manager.extraFrames[1] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("T")
                                .foregroundStyle(.gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 2 ? manager.extraFrames[2] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("R")
                                .foregroundStyle(.gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 3 ? manager.extraFrames[3] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                            Text("A")
                                .foregroundStyle(.gray)
                                .font(.custom("MrDo-Arcade", size: TopView.extraInsideTextSize))
                                .padding(0)
                                .overlay(
                                    Image(uiImage: manager.extraCurrent == 4 ? manager.extraFrames[4] : UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:TopView.liveSize.width,height: TopView.liveSize.height)
                                        .background(.clear)
                                )
                        }.padding(4)
                    )
            }.frame(width: TopView.liveSize.width * 5)
            VStack {
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
}
