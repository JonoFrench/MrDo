//
//  MiddleView.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import SwiftUI

struct MiddleView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack(alignment: .center) {
            ScreenView(gameScreen: manager.gameScreen)
                .frame(height: manager.gameScreen.assetDimension * 13, alignment: .center)
                .zIndex(3.0)
            ForEach(manager.appleArray, id: \.id) { apple in
                AppleView(apple: apple)
                    .position(apple.position)
                    .zIndex(2.1)
            }
        }
    }
}

#Preview {
    MiddleView()
}
