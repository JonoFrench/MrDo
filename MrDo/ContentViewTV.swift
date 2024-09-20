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
                    else if manager.gameState == .playing {
                        GameView(mrDo: manager.mrDo)
                            .zIndex(1.0)
                    }
                    else if manager.gameState == .highscore {
                    }
                }.background(.black)
                Spacer()
            }.frame(width:864, height: UIScreen.main.bounds.height,alignment: .center)
            Spacer()
        }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height,alignment: .center)
            .background(.black)
    }
}

#Preview {
    ContentViewTV()
}
