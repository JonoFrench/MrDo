//
//  GameOverView.swift
//  MrDo
//
//  Created by Jonathan French on 16.10.24.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var manager: GameManager

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .frame(width: manager.screenData.gameSize.width / 1.50,height: manager.screenData.gameSize.width / 4.0,alignment: .center)
                .overlay(alignment: .center, content: {
                    Text("GAME OVER")
                        .foregroundStyle(.cyan)
                        .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
                })
        }
    }
}

#Preview {
    GameOverView()
}
