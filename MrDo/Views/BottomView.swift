//
//  BottomView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct BottomView: View {
    @EnvironmentObject var manager: GameManager

    var body: some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: 4) {  // Adjust spacing to bring images closer
                ForEach(0..<manager.lives, id: \.self) { _ in
                    ImageView(image: ImageResource(name: "Life", bundle: .main), frameSize: GameConstants.Size.lifeSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)  // Make the HStack left-justified
            Spacer()
            VStack(alignment: .leading, content: {
                Text("SCENE....\(String(format: "%02d", manager.screenData.actualLevel))")
                    .foregroundStyle(.green)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
                    .padding([.trailing])
                Text("TOP  \(String(format: "%06d", manager.hiScores.highScore))")
                    .foregroundStyle(.red)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
                    .padding([.trailing])
            })
        }.zIndex(2.0)
    }
}

#Preview {
    BottomView()
        .environmentObject(GameManager())
        .frame(height: 100)
        .background(.black)
}
