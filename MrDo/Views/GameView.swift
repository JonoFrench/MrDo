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
    var body: some View {
        VStack(alignment:.center, spacing: .zero) {
            TopView()
                .frame(height: manager.gameScreen.assetDimension * 1 , alignment: .center)
                .background(.black)
                .zIndex(3.0)
            if manager.gameState == .progress {
                ProgressView(progress: manager.progress)
            } else if manager.gameState == .progress10 {
                ZStack(alignment: .center) {
                    Progress10View(manager: _manager)
                }
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
                    ForEach(appleArray.apples, id: \.id) { apple in
                        AppleView(apple: apple)
                            .zIndex(1.6)
                    }
                    ForEach(redMonsterArray.monsters, id: \.id) { monster in
                        RedMonsterView(redMonster: monster)
                            .zIndex(1.7)
                    }
                    CenterView(center: manager.center)
                        .position(manager.center.position)
                        .zIndex(1.5)
                    if manager.gameScreen.gameOver {
                        GameOverView(manager: _manager)
                            .position(x:manager.gameScreen.gameSize.width / 2,y: manager.gameScreen.gameSize.height / 2).offset(y: -40)
                            .zIndex(5)
                    }
                }
            }
            BottomView()
                .frame(height: manager.gameScreen.assetDimension * 1, alignment: .center)
                .zIndex(3.0)
                .background(.black)
        }
    }
}
