//
//  GameView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var manager: GameManager
    @ObservedObject var mrDo:MrDo
    @ObservedObject var ball:Ball
    @ObservedObject var appleArray:AppleArray
    @ObservedObject var redMonsterArray:RedMonsterArray
    @ObservedObject var extraMonsterArray:ExtraMonsterArray
    var body: some View {
        VStack(alignment:.center, spacing: .zero) {
            TopView()
                .frame(height: manager.gameScreen.assetDimension * 1 , alignment: .center)
                .background(.black)
                .zIndex(2.0)
            if manager.gameState == .progress {
                ProgressView(progress: manager.progress)
            } else if manager.gameState == .progress10 {
                ZStack(alignment: .center) {
                    Progress10View(manager: _manager)
                }
            }
            else if manager.gameState == .extralife {
//                ZStack(alignment: .center) {
                ExtraLifeView(extraLife:manager.extraLife,ball: manager.extraLife.ball)
//                }
            } else {
                ZStack(alignment: .center) {
                    ScreenView(gameScreen: manager.gameScreen)
                    //.frame(height: manager.gameScreen.assetDimension * 13, alignment: .center)
                        .zIndex(0.5)
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
                    ForEach(redMonsterArray.monsters, id: \.id) { monster in
                        RedMonsterView(redMonster: monster)
                            .zIndex(1.7)
                    }
                    ForEach(extraMonsterArray.monsters, id: \.id) { monster in
                        ExtraMonsterView(extraMonster: monster)
                            .zIndex(3.8)
                    }
                    CenterView(center: manager.center)
                        .position(manager.center.position)
                        .zIndex(1.5)
                    if manager.gameScreen.gameOver {
                        GameOverView(manager: _manager)
                            .position(x:manager.gameScreen.gameSize.width / 2,y: manager.gameScreen.gameSize.height / 2).offset(y: -40)
                            .zIndex(5)
                    }
                }.zIndex(2.9)
            }
            BottomView()
                .frame(height: manager.gameScreen.assetDimension * 1, alignment: .center)
                .zIndex(3.0)
                .background(.black)
        }
    }
}
