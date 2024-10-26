//
//  ExtraLifeView.swift
//  MrDo
//
//  Created by Jonathan French on 24.10.24.
//

import SwiftUI

struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ExtraLifeView: View {
    @EnvironmentObject var manager: GameManager
    @ObservedObject var extraLife: ExtraLife
    @ObservedObject var ball:Ball

#if os(iOS)
    static var titleTextSize:CGFloat = 18
    static var subTitleTextSize:CGFloat = 12
    static var scoreTextSize:CGFloat = 16
    static var starttextSize:CGFloat = 14
    static var typeSize = 30.0
    static var wonderSize = CGSize(width: 0, height: 236)
#elseif os(tvOS)
    static var titleTextSize:CGFloat = 28
    static var subTitleTextSize:CGFloat = 24
    static var scoreTextSize:CGFloat = 24
    static var starttextSize:CGFloat = 28
    static var typeSize = 60.0
    static var wonderSize = CGSize(width: 0, height: 586)
#endif
    
    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                Image(extraLife.backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: extraLife.backgroundFrameSize.width, height: extraLife.backgroundFrameSize.height)
                    .background(.clear)
                    .position(extraLife.backgroundPosition)
                
                Image(extraLife.doImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: extraLife.doFrameSize.width, height: extraLife.doFrameSize.height)
                    .background(.clear)
                    .position(extraLife.doPosition)

                Image(extraLife.monsterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: extraLife.monsterFrameSize.width, height: extraLife.monsterFrameSize.height)
                    .background(.clear)
                    .position(extraLife.monsterPosition)

                if extraLife.state == .ballthrown {
                    Image(extraLife.ballImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: extraLife.ballFrameSize.width, height: extraLife.ballFrameSize.height)
                        .background(.clear)
                        .position(extraLife.doBallPosition)
                }
                if extraLife.state == .flagwaving {
                    Image(extraLife.flagImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: extraLife.flagFrameSize.width, height: extraLife.flagFrameSize.height)
                        .background(.clear)
                        .position(extraLife.flagPosition)
                }
                
                if extraLife.ball.exploding || extraLife.ball.imploding {
                    ForEach(extraLife.ball.explodeArray,id: \.id) { ballExplode in
                        BallView(ball: extraLife.ball)
                            .position(ballExplode.position)
                            .zIndex(5.9)
                    }
                }

                
            }.frame(width: manager.gameScreen.gameSize.width, height: manager.gameScreen.gameSize.width)
            ZStack(alignment: .center) {
                //            Spacer()
                HStack(alignment: .top,spacing: 20) {
                    Spacer()
                    VStack {
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    VStack(alignment: .center,spacing: 20) {
                        Text("")
                        Text("CONGRATULATIONS")
                            .foregroundStyle(.yellow)
                            .font(.custom("MrDo-Arcade", size: ExtraLifeView.titleTextSize))
                            .padding([.leading, .trailing])
                            .lineLimit(1)
                            .fixedSize()
                        Text("YOU WIN")
                            .foregroundStyle(.black)
                            .font(.custom("MrDo-Arcade", size: ExtraLifeView.titleTextSize))
                            .padding([.leading])
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text("EXTRA")
                                .foregroundStyle(.black)
                                .font(.custom("MrDo-Arcade", size: ExtraLifeView.titleTextSize))
                                .padding([.leading])
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("MR DO!")
                                .foregroundStyle(.pink)
                                .font(.custom("MrDo-Arcade", size: ExtraLifeView.titleTextSize))
                                .padding([.trailing])
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Spacer()
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.clear)
                    VStack {
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }.background(.clear)
            }
        }
    }
}
