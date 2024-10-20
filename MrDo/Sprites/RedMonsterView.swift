//
//  RedMonsterView.swift
//  MrDo
//
//  Created by Jonathan French on 17.10.24.
//

import SwiftUI

struct RedMonsterView: View {
    @ObservedObject var redMonster:RedMonster
    var body: some View {
        ZStack {
            Image(uiImage: redMonster.currentImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: redMonster.frameSize.width, height: redMonster.frameSize.height)
                .background(.clear)
                .zIndex(2.1)
        }.background(.clear)
            .frame(width: 1,height: 1,alignment: .center)
            .position(redMonster.position)

    }}

