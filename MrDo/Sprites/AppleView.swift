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
            Image(uiImage: apple.currentImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: apple.frameSize.width, height: apple.frameSize.height)
                    .background(.clear)
        }.background(.clear)
            .frame(width: 1,height: 1,alignment: .center)
    }
}

//#Preview {
//    AppleView()
//}
