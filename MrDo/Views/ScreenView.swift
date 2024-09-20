//
//  ScreenView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI
import UIKit

struct ScreenView: View {
    @EnvironmentObject var manager: GameManager
    @ObservedObject var gameScreen: ScreenData
    var body: some View {
        ZStack(alignment: .center)  {
            ForEach(0..<gameScreen.screenDimensionY, id: \.self) { y in
                ForEach(0..<gameScreen.screenDimensionX, id: \.self) { x in
                    let ir = gameScreen.levelData.tileArray[y][x]
                    Image(uiImage:gameScreen.levelData.tileImages[ir.rawValue])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: gameScreen.assetDimension, height: gameScreen.assetDimension)
                            .position(x:Double(x) * gameScreen.assetDimension + (gameScreen.assetDimension / 2),y: Double(y) * gameScreen.assetDimension + (gameScreen.assetDimension / 2))
                }
            }
        }.zIndex(0.1)
   }
}

//#Preview {
//    ScreenView()
//}
