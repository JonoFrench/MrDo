//
//  StartView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct StartView: View {
#if os(iOS)
    static var starttextSize:CGFloat = 14
    static var copyTextSize:CGFloat = 12
#elseif os(tvOS)
    static var starttextSize:CGFloat = 24
    static var copyTextSize:CGFloat = 28
#endif

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                Image("Title")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                Text("Jonathan French 2024")
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: StartView.starttextSize))
                Spacer()
                Text("(C) 1982 Universal")
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: StartView.copyTextSize))
                Spacer()
                Text(GameConstants.startText)
                    .foregroundStyle(.red)
                    .font(.custom("MrDo-Arcade", size: StartView.starttextSize))
                //Spacer()
            }
        }.background(.black)
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return StartView()
        .environmentObject(previewEnvObject)
    
}
