//
//  IntroView.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

struct IntroView: View {
    @EnvironmentObject var manager: GameManager
    @State private var currentIndex = 0
    private let numberOfViews = 2
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $currentIndex) {
                if currentIndex == 0 {
                    StartView(appleArray: manager.appleArray,mrDo: manager.mrDo,extraMonsterArray: manager.extraMonsterArray,ball: manager.ball)
                } else {
                    HiScoreView()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                print("game size \(proxy.size)")
                manager.screenData.gameSize = proxy.size
                manager.setInit()
                startTimer()
            }.background(.clear)
        }
    }
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            withAnimation {
                currentIndex = (currentIndex + 1) % numberOfViews
                Task { @MainActor in
                    if currentIndex == 0 { manager.resetIntroScreen() }
                }
            }
        }
    }}
