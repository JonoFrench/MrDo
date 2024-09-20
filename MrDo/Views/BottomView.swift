//
//  BottomView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct BottomView: View {
    @EnvironmentObject var manager: GameManager
#if os(iOS)
    static var topTextSize:CGFloat = 14
    static var copyTextSize:CGFloat = 12
    static var liveSize = CGSize(width: 24, height: 24)
#elseif os(tvOS)
    static var topTextSize:CGFloat = 28
    static var copyTextSize:CGFloat = 28
    static var liveSize = CGSize(width: 48, height: 48)
#endif

    var body: some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: 4) {  // Adjust spacing to bring images closer
                ForEach(0..<manager.lives, id: \.self) { _ in
                    ImageView(image: ImageResource(name: "Life", bundle: .main), frameSize: BottomView.liveSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)  // Make the HStack left-justified

            Spacer()
            VStack(alignment: .leading, content: {
                Text("SCENE.....\(String(format: "%01d", manager.gameScreen.level))")
                    .foregroundStyle(.green)
                    .font(.custom("MrDo-Arcade", size: BottomView.topTextSize))
                    .padding([.trailing])
                Text("TOP  \(String(format: "%06d", manager.hiScores.highScore))")
                    .foregroundStyle(.red)
                    .font(.custom("MrDo-Arcade", size: BottomView.topTextSize))
                    .padding([.trailing])
            })
        }
    }
}

//#Preview {
//    BottomView()
//}
