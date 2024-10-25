//
//  ExtraLife.swift
//  MrDo
//
//  Created by Jonathan French on 24.10.24.
//

import Foundation
import SwiftUI

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
    var backgroundCount = 0
    var ballCount = 0
    let doImages:[ImageResource] = [ImageResource(name: "ExtraLifeDo1", bundle: .main),ImageResource(name: "ExtraLifeDo2", bundle: .main)]
    let doBallImages:[ImageResource] = [ImageResource(name: "ExtraLifeDo3", bundle: .main),ImageResource(name: "ExtraLifeDo4", bundle: .main)]
    var animateFlip = false
    var moveBall = false
    var showFlag = false
    var explodeBall = false
#if os(iOS)
    var backgroundFrameSize: CGSize = CGSize(width: 80, height: 80)
    var doFrameSize : CGSize = CGSize(width: 64, height: 70)
    var ballFrameSize : CGSize = CGSize(width: 30, height: 30)
    var flagFrameSize : CGSize = CGSize(width: 48, height: 48)
    var monsterFrameSize : CGSize = CGSize(width: 124, height: 124)
    var speed = 8.0
#elseif os(tvOS)
    var backgroundFrameSize: CGSize = CGSize(width: 160, height: 160)
    var doFrameSize : CGSize = CGSize(width: 160, height: 160)
    var ballFrameSize : CGSize = CGSize(width: 60, height: 60)
    var doBallFrameSize : CGSize = CGSize(width: 24, height: 24)
    var monsterFrameSize : CGSize = CGSize(width: 160, height: 160)
    var flagFrameSize : CGSize = CGSize(width: 96, height: 96)
    var speed = 16.0
#endif
    
    init() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            let width = screenData.gameSize.width / 208.0
            let backgroundX = width * 265 - (screenData.gameSize.width / 2) - 48
            backgroundFrameSize = CGSize(width: width * 265, height: screenData.gameSize.width)
            backgroundPosition = CGPoint(x: backgroundX, y: screenData.gameSize.height / 2 - 80)
            doPosition = CGPoint(x: screenData.gameSize.width / 3 - 20, y: screenData.gameSize.height / 2 )
            doBallPosition = CGPoint(x: screenData.gameSize.width / 3 - 8, y: screenData.gameSize.height / 2 - 8)
            monsterPosition = CGPoint(x: screenData.gameSize.width + 8, y: screenData.gameSize.height / 2 - 19.5)
            extraPosition = CGPoint(x: screenData.gameSize.width / 4, y: screenData.gameSize.height - 150)
            flagPosition = CGPoint(x: screenData.gameSize.width - 180, y: screenData.gameSize.height / 2 - 16)
       }
    }
    
    
    func move() {
        speedCounter += 1
        if speedCounter == 3 {
            speedCounter = 0
            if backgroundCount < 58 {
                backgroundCount += 1
                print("background \(backgroundCount)")
                backgroundPosition.x -= 2.0
                monsterPosition.x -= 2.0
            }
            else if backgroundCount == 58 && !moveBall {
                backgroundCount += 1
                moveBall = true
                doImage = ImageResource(name: "ExtraLifeDo3", bundle: .main)
            }
            if moveBall {
                ballCount += 1
                doBallPosition.x += 8
                if ballCount < 10 {
                    doBallPosition.y += 8
                } else {
                    doBallPosition.y -= 8
                }
                if ballCount == 20 {
                    moveBall = false
                    showFlag = true
                    monsterImage = ImageResource(name: "ExtraLife2", bundle: .main)
                    ball.setExplode(position: doBallPosition)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                        ball.setImplode(position: extraPosition)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            NotificationCenter.default.post(name: .notificationExtraLife, object: nil, userInfo: nil)
                        }
                    }
                }
            }
        }
    }
    
    func animate() {
        currentAnimationFrame += 1
        if currentAnimationFrame == 8 {
            currentAnimationFrame = 0
            if backgroundCount < 58 {
                doImage = doImages[animateFlip ? 0:1]
                animateFlip = !animateFlip
            }
            if moveBall {
                doImage = ImageResource(name: "ExtraLifeDo4", bundle: .main)
            }
            
            if showFlag {
                animateFlip = !animateFlip
                flagImage = animateFlip ? ImageResource(name: "ExtraLifeFlag1", bundle: .main) : ImageResource(name: "ExtraLifeFlag2", bundle: .main)
                flagPosition.y += animateFlip ? -24 : 24
            }
        }
    }
    
}
