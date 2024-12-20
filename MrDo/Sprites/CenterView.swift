//
//  CenterView.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import SwiftUI

struct CenterView: View {
    @ObservedObject var center:Center
    var body: some View {
        ZStack {
            Image(center.currentFrame)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: center.frameSize.width, height: center.frameSize.height)
                .background(.clear)
        }.background(.clear)
    }
}
