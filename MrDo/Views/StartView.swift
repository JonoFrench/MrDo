//
//  StartView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Image("Title")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                Text("Jonathan French 2024")
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
                Spacer()
                Text("(C) 1982 Universal")
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.copyTextSize))
                Spacer()
                Text(GameConstants.Text.startText)
                    .foregroundStyle(.red)
                    .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
            }
        }.background(.black)
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return StartView()
        .environmentObject(previewEnvObject)
    
}
