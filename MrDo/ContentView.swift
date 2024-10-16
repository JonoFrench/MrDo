//
//  ContentView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack(alignment: .top) {
            Color(.black)
            VStack(spacing: 0) {
                Spacer()
                if manager.gameState == .intro {
                    IntroView()
                        .frame(maxWidth: .infinity)
                        .background(.clear)
                }
                else if manager.gameState == .playing || manager.gameState == .levelend || manager.gameState == .progress {
                    GameView(mrDo: manager.mrDo,ball: manager.ball,appleArray:manager.appleArray)
                        .frame(width: UIScreen.main.bounds.width, height: manager.gameScreen.assetDimension * 15, alignment: .center)
                            .zIndex(1.0)
                }
                else if manager.gameState == .highscore {
                    NewHighScoreView(hiScores: manager.hiScores)
                        .background(.clear)
                        .zIndex(1.0)
                }
                Spacer()

                ControlsView()
                    .frame(maxWidth: .infinity)
                    //.ignoresSafeArea(.all)
                    .zIndex(2.0)
                    .background(.black)
            }.background(.black)

        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            //.edgesIgnoringSafeArea(.bottom)
//            .onAppear(perform: {
//                for family in UIFont.familyNames.sorted() {
//                    print("Family: \(family)")
//    
//                    let names = UIFont.fontNames(forFamilyName: family)
//                    for fontName in names {
//                        print("- \(fontName)")
//                    }
//                }
//            })
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return ContentView()
        .environmentObject(previewEnvObject)
}

////        .onAppear(perform: {
////            for family in UIFont.familyNames.sorted() {
////                print("Family: \(family)")
////
////                let names = UIFont.fontNames(forFamilyName: family)
////                for fontName in names {
////                    print("- \(fontName)")
////                }
////            }
////        })
