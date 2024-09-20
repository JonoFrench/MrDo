//
//  MrDoView.swift
//  MrDo
//
//  Created by Jonathan French on 19.09.24.
//

import SwiftUI

struct MrDoView: View {
    @ObservedObject var mrDo:MrDo
    var body: some View {
        ZStack {
            Image(uiImage: mrDo.currentImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: mrDo.frameSize.width, height: mrDo.frameSize.height)
                .background(.clear)
                .zIndex(2.1)
//                .overlay(alignment: .center, content: {
//                    Circle()
//                        .fill(Color.yellow)
//                        .frame(width: barrel.frameSize.width / 2, height: barrel.frameSize.height / 2)
//                        .zIndex(2.1)
//                        .offset(y:-barrel.frameSize.height)
//                })
        }.background(.clear)
            .frame(width: 1,height: 1,alignment: .center)
    }
}
