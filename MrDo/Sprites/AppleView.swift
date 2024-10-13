//
//  AppleView.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import SwiftUI

struct AppleView: View {
    @ObservedObject var apple:Apple
    var body: some View {
        ZStack {
            if apple.appleState == .breaking {
                HStack(spacing: 0){
                    Image(uiImage:apple.leftImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: apple.frameSize.width, height: apple.frameSize.height)
                        .background(.clear)
                    .zIndex(2.1)
                        .padding([.leading])
                    Image(uiImage:apple.rightImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: apple.frameSize.width, height: apple.frameSize.height)
                        .background(.clear)
                        .padding([.trailing])
                    .zIndex(2.1)
                }
            } else {
                Image(uiImage: apple.currentImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: apple.frameSize.width, height: apple.frameSize.height)
                    .background(.clear)
                    .zIndex(2.1)
            }
        }.background(.clear)
            .frame(width: 1,height: 1,alignment: .center)
            .position(apple.position)
    }
    
}
