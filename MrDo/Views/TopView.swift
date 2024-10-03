//
//  TopView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var manager: GameManager
#if os(iOS)
    static var topTextSize:CGFloat = 14
    static var extraTextSize:CGFloat = 20
    static var liveSize = CGSize(width: 24, height: 24)
#elseif os(tvOS)
    static var topTextSize:CGFloat = 28
    static var extraTextSize:CGFloat = 40
    static var liveSize = CGSize(width: 48, height: 48)
//#elseif os(iPadOS)
//    static var topTextSize:CGFloat = 28
//    static var extraTextSize:CGFloat = 40
//    static var liveSize = CGSize(width: 48, height: 48)
//
#endif
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack {
                Text("1ST")
                    .foregroundStyle(.green)
                    .font(.custom("MrDo-Arcade", size: TopView.topTextSize))
                    .padding([.trailing])
                Text("\(String(format: "%06d", manager.score))")
                    .foregroundStyle(.white)
                    .font(.custom("MrDo-Arcade", size: TopView.topTextSize))
                    .padding([.trailing])
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            VStack {
                Text("EXTRA")
                    .foregroundStyle(.gray)
                    .font(.custom("MrDo-Arcade", size: TopView.extraTextSize))
                    .padding(4)
                    .overlay(
                        Rectangle()
                            .stroke(.yellow,lineWidth: 3)
                    )
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            VStack {
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
}

//#Preview {
//    TopView()
//}
