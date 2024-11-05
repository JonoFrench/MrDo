//
//  StartView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var manager: GameManager
    @ObservedObject var appleArray:AppleArray
    @ObservedObject var mrDo:MrDo
    @ObservedObject var extraMonsterArray:ExtraMonsterArray
    @ObservedObject var ball:Ball
    var body: some View {
        VStack(alignment: .center) {
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            ZStack(alignment: .top) {
                ScreenView(gameScreen: manager.screenData)
                    .overlay(alignment: .top, content: {
                        VStack(alignment: .center, spacing: 10) {
                            Text("")
                            Text("Jonathan French 2024")
                                .foregroundStyle(.white)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
                            Text("")
                            Text("(C) 1982 Universal")
                                .foregroundStyle(.white)
                                .font(.custom("MrDo-Arcade", size: GameConstants.Text.copyTextSize))
                        }
                    }).zIndex(4.0)
                MrDoView(mrDo: mrDo)
                    .position(mrDo.position)
                    .zIndex(2.0)
                if ball.thrown {
                    BallView(ball: ball)
                        .position(ball.position)
                        .zIndex(1.9)
                }
                if ball.exploding || ball.imploding {
                    ForEach(ball.explodeArray,id: \.id) { ballExplode in
                        BallView(ball: ball)
                            .position(ballExplode.position)
                            .zIndex(1.9)
                    }
                }
                ForEach(appleArray.apples, id: \.id) { apple in
                    AppleView(apple: apple)
                        .zIndex(1.6)
                }
                ForEach(extraMonsterArray.monsters, id: \.id) { monster in
                    ExtraMonsterView(extraMonster: monster)
                        .zIndex(1.7)
                }
            }
            
            .zIndex(0.5)
            Spacer()
            Spacer()
            Text(GameConstants.Text.startText)
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
                .zIndex(1.0)
        }.background(.black)
            .onAppear {
                manager.setInit()
            }
    }
}
