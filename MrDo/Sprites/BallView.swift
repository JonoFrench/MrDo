//
//  BallView.swift
//  MrDo
//
//  Created by Jonathan French on 20.09.24.
//

import SwiftUI

struct BallView: View {
    @ObservedObject var ball:Ball
    var body: some View {
        ZStack {
            Image(ball.currentFrame)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ball.frameSize.width, height: ball.frameSize.height)
                    .background(.clear)
        }.background(.clear)
            .frame(width: 1,height: 1,alignment: .center)
    }
}
