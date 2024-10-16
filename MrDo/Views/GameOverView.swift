//
//  GameOverView.swift
//  MrDo
//
//  Created by Jonathan French on 16.10.24.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var manager: GameManager
#if os(iOS)
    static var textSize:CGFloat = 14
#elseif os(tvOS)
    static var textSize:CGFloat = 28
#endif

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .frame(width: manager.gameScreen.gameSize.width / 1.50,height: manager.gameScreen.gameSize.width / 4.0,alignment: .center)
                .overlay(alignment: .center, content: {
                    Text("GAME OVER")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: GameOverView.textSize))
                })
        }
    }
}

#Preview {
    GameOverView()
}
