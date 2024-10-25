//
//  ExtraMonsterView.swift
//  MrDo
//
//  Created by Jonathan French on 23.10.24.
//

import SwiftUI

import SwiftUI

struct ExtraMonsterView: View {
    @ObservedObject var extraMonster:ExtraMonster
    var body: some View {
        ZStack {
            Image(uiImage: extraMonster.currentImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: extraMonster.frameSize.width, height: extraMonster.frameSize.height)
                .background(.clear)
                .zIndex(extraMonster.extraType == .letter ? 3.8: 3.4)
        }.background(.clear)
            .frame(width: 1,height: 1,alignment: .center)
            .position(extraMonster.position)

    }}

