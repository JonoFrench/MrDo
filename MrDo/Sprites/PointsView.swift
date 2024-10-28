//
//  PointsView.swift
//  MrDo
//
//  Created by Jonathan French on 27.10.24.
//

import SwiftUI

struct PointsView: View {
    @ObservedObject var points:Points
    var body: some View {
        ZStack {
            Image(points.currentFrame)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: points.frameSize.width, height: points.frameSize.height)
                .background(.clear)
        }.background(.clear)
    }}
