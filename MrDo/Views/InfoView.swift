//
//  InfoView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            //            Spacer()
            //            Image("Instructions")
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .frame(width: 50, height: 50)
            //                .rotationEffect(.degrees(90))
            Spacer()
            Text(GameConstants.Text.startText)
                .foregroundStyle(.red)
                .font(.custom("MrDo-Arcade", size: GameConstants.Text.starttextSize))
            //            Spacer()
        }.background(.black)
    }
}
#Preview {
    InfoView()
}
