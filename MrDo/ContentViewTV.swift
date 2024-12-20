//
//  ContentViewTV.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct ContentViewTV: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ZStack(alignment: .center) {
                Color(.black)
                VStack(alignment: .center) {
                    if manager.gameState == .intro {
                        Spacer()
                        IntroView()
                            .background(.clear)
                        Spacer()
                        Spacer()
                    }
                    else if manager.gameState == .playing || manager.gameState == .levelend || manager.gameState == .progress || manager.gameState == .progress10 || manager.gameState == .extralife {
                        GameView(mrDo: manager.mrDo,ball: manager.ball,appleArray:manager.appleArray,redMonsterArray:manager.redMonsterArray,extraMonsterArray:manager.extraMonsterArray)
                            .zIndex(1.0)
                    }
                    else if manager.gameState == .highscore {
                        NewHighScoreView(hiScores: manager.hiScores)
                            .background(.clear)
                            .zIndex(1.0)
                    }
                }.background(.black)
                Spacer()
            }.frame(width:864, height: UIScreen.main.bounds.height,alignment: .center)
                .clipped()
            Spacer()
        }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height,alignment: .center)
            .background(.black)
    }
}

#Preview {
    ContentViewTV()
}
