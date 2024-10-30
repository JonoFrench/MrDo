//
//  ExtraLife.swift
//  MrDo
//
//  Created by Jonathan French on 24.10.24.
//

import Foundation
import SwiftUI

enum ExtraLifeState {
    case scrolling,ballthrown,flagwaving
}

final class ExtraLife: ObservableObject, Moveable {
    static var speed: Int = 2
    var speedCounter: Int = 0
    var currentAnimationFrame: Int = 0
    @Published
    var backgroundImage:ImageResource = ImageResource(name: "ExtraLifeBackground", bundle: .main)
    @Published
    var doImage:ImageResource = ImageResource(name: "ExtraLifeDo1", bundle: .main)
    @Published
    var monsterImage:ImageResource = ImageResource(name: "ExtraLife1", bundle: .main)
    @Published
    var ballImage:ImageResource = ImageResource(name: "ExtraLifeBall", bundle: .main)
    @Published
    var flagImage:ImageResource = ImageResource(name: "ExtraLifeFlag1", bundle: .main)
    let doImages:[ImageResource] = [ImageResource(name: "ExtraLifeDo1", bundle: .main),ImageResource(name: "ExtraLifeDo2", bundle: .main)]
    
    @Published
    var backgroundPosition = CGPoint()
    @Published
    var monsterPosition = CGPoint()
    @Published
    var doBallPosition = CGPoint()
    @ObservedObject
    var ball:Ball = Ball()
    var extraPosition = CGPoint()
    var doPosition = CGPoint()
    var flagPosition = CGPoint()
    
    var counter = 0
    var state:ExtraLifeState = .scrolling
    var animateFlip = false
#if os(iOS)
    var backgroundFrameSize: CGSize = CGSize(width: 80, height: 80)
    var doFrameSize : CGSize = CGSize(width: 64, height: 70)
    var ballFrameSize : CGSize = CGSize(width: 30, height: 30)
    var flagFrameSize : CGSize = CGSize(width: 48, height: 48)
    var monsterFrameSize : CGSize = CGSize(width: 124, height: 124)
    var speed = 8.0
    let startWidth = 48.0
    let backgroundAdjust = 80.0
    let doAdjust = 20.0
    let ballAdjust = 8.0
    let monsterAdjustWidth = 8.0
    let monsterAdjustHeight = 19.5
    let backgroundSpeed = 2.0
    let flagAdjustWidth = 180.0
    let flagAdjustHeight = 16.0
    let extraAdjust = 150.0
#elseif os(tvOS)
    var backgroundFrameSize: CGSize = CGSize(width: 160, height: 160)
    var doFrameSize : CGSize = CGSize(width: 128, height: 140)
    var ballFrameSize : CGSize = CGSize(width: 60, height: 60)
    var doBallFrameSize : CGSize = CGSize(width: 24, height: 24)
    var monsterFrameSize : CGSize = CGSize(width: 270, height: 270)
    var flagFrameSize : CGSize = CGSize(width: 96, height: 96)
    var speed = 16.0
    let startWidth = 96.0
    let backgroundAdjust = 160.0
    let doAdjust = 40.0
    let ballAdjust = 8.0
    let monsterAdjustWidth = 26.0
    let monsterAdjustHeight = 26.5
    let backgroundSpeed = 4.0
    let flagAdjustWidth = 360.0
    let flagAdjustHeight = 0.0
    let extraAdjust = 300.0
#endif
    
    init() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            ///Background image is 265 x 208
            let width = screenData.gameSize.width / 208.0
            let backgroundX = width * 265 - (screenData.gameSize.width / 2) - startWidth
            backgroundFrameSize = CGSize(width: width * 265, height: screenData.gameSize.width)
            backgroundPosition = CGPoint(x: backgroundX, y: screenData.gameSize.height / 2 - backgroundAdjust)
            doPosition = CGPoint(x: screenData.gameSize.width / 3 - doAdjust, y: screenData.gameSize.height / 2 )
            doBallPosition = CGPoint(x: screenData.gameSize.width / 3 - ballAdjust, y: screenData.gameSize.height / 2 - ballAdjust)
            monsterPosition = CGPoint(x: screenData.gameSize.width + monsterAdjustWidth, y: screenData.gameSize.height / 2 - monsterAdjustHeight)
            extraPosition = CGPoint(x: screenData.gameSize.width / 4, y: screenData.gameSize.height - extraAdjust)
            flagPosition = CGPoint(x: screenData.gameSize.width - flagAdjustWidth, y: screenData.gameSize.height / 2 - flagAdjustHeight)
            state = .scrolling
        }
    }
    
    func move() {
        speedCounter += 1
        if speedCounter == 3 {
            speedCounter = 0
            if state == .scrolling {
                counter += 1
                backgroundPosition.x -= backgroundSpeed
                monsterPosition.x -= backgroundSpeed
                if counter == 58 {
                    state = .ballthrown
                    counter = 0
                    doImage = ImageResource(name: "ExtraLifeDo3", bundle: .main)
                }
            }
            if state == .ballthrown {
                counter += 1
                doBallPosition.x += speed
                if counter < 10 {
                    doBallPosition.y += speed
                } else {
                    doBallPosition.y -= speed
                }
                if counter == 20 {
                    state = .flagwaving
                    monsterImage = ImageResource(name: "ExtraLife2", bundle: .main)
                    ball.setExplode(position: doBallPosition)
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(GameConstants.Delay.extraLifeDelay1))
                        ball.setImplode(position: extraPosition)
                        try? await Task.sleep(for: .seconds(GameConstants.Delay.extraLifeDelay2))
                        NotificationCenter.default.post(name: .notificationExtraLife, object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
    
    func animate() {
        currentAnimationFrame += 1
        if currentAnimationFrame == 8 {
            currentAnimationFrame = 0
            if state == .scrolling {
                doImage = doImages[animateFlip ? 0:1]
                animateFlip = !animateFlip
            }
            else if state == .ballthrown {
                doImage = ImageResource(name: "ExtraLifeDo4", bundle: .main)
            }
            else if state == .flagwaving {
                animateFlip = !animateFlip
                flagImage = animateFlip ? ImageResource(name: "ExtraLifeFlag1", bundle: .main) : ImageResource(name: "ExtraLifeFlag2", bundle: .main)
                flagPosition.y += animateFlip ? -24 : 24
            }
        }
    }
}
