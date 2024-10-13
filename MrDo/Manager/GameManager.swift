//
//  GameManager.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import QuartzCore
import SwiftUI
import Combine


enum GameState {
    case intro,kongintro,howhigh,playing,ended,highscore,levelend
}

enum JoyPad {
    case left,right,up,down,stop
}

struct GameConstants {
    static let tileSteps = 8.0
    static let doSpeed = 2
    static let ballSpeed = 2

    
#if os(iOS)
    static var doSize = CGSize(width: 32, height: 32)
   static var startText = "PRESS JUMP TO START"
#elseif os(tvOS)
    static var doSize = CGSize(width: 64, height: 64)
    static var startText = "PRESS A TO START"
#endif
}

class GameManager: ObservableObject {
    let soundFX:SoundFX = SoundFX()
    let hiScores:MrDoHighScores = MrDoHighScores()
    @Published
    var gameScreen:ScreenData = ScreenData()
    @Published
    var gameState:GameState = .intro
    @Published
    var lives = 3
    var score = 0
    var moveDirection: JoyPad {
        didSet {
            if moveDirection != oldValue {
                handleJoyPad()
            }
        }
    }
    @ObservedObject
    var mrDo:MrDo = MrDo(xPos: 0, yPos: 0, frameSize: GameConstants.doSize)
    @ObservedObject
    var appleArray:AppleArray = AppleArray()
    var center:Center = Center(xPos: 5, yPos: 6)
    @ObservedObject
    var ball:Ball = Ball()
    /// So we can turn off collisions to test
    var turnOffCollisions = false
    var checkCounter:Int = 0 {
        didSet {
            if checkCounter > 4 {
                checkCounter = 0
            }
        }
    }
    
    init() {
        moveDirection = .stop
        /// Share these instances so they are available from the Sprites
        ServiceLocator.shared.register(service: gameScreen)
        ServiceLocator.shared.register(service: appleArray)
        ///Here we go, lets have a nice DisplayLink to update our model with the screen refresh.
        let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(refreshModel))
        displayLink.add(to: .main, forMode:.common)
        notificationObservers()
    }
    
    func startGame() {
#if os(iOS)
        gameScreen.assetDimension = gameScreen.gameSize.width / Double(gameScreen.screenDimensionX)
#elseif os(tvOS)
        gameScreen.assetDimension = gameScreen.gameSize.height / 14 //Double(gameScreen.screenDimensionX + 3)
#endif
print("Asset dim \(gameScreen.assetDimension) width should be \(gameScreen.assetDimension * 12)")
        gameScreen.assetDimensionStep = gameScreen.assetDimension / GameConstants.tileSteps


        lives = 3
        score = 0
//        turnOffCollisions = true
        startPlaying()
    }
    
    func handleJoyPad() {
        guard !mrDo.willStop else {return}
        switch moveDirection {
        case .down:
            if gameState == .playing {
                mrDo.direction = .down
            }
        case .left:
            if gameState == .playing {
                mrDo.direction = .left
            }
        case .right:
            if gameState == .playing {
                mrDo.direction = .right
            }
        case .up:
            if gameState == .playing {
                    mrDo.direction = .up
            }
        case.stop:
            print("handleJoyPad stop")
            mrDo.willStop = true
        }
    }
    
    @objc func refreshModel() {
        if gameState == .playing {
            mrDo.move()
            if ball.thrown {
                catchBall()
                ball.move()
            }
            appleArray.checkDrop(doXpos: mrDo.xPos,doYpos: mrDo.yPos)
            appleArray.move()
        }
    }
    
    func startPlaying() {
        gameScreen.pause = false
        gameScreen.levelEnd = false
        gameScreen.gameOver = false
//        gameScreen.level = 1
        setDataForLevel()
        gameState = .playing
    }
    
    func catchBall(){
        guard ball.catchable else { return }
        if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: mrDo.position, diameter2: mrDo.frameSize.width / 2 ){
            ball.thrown = false
            ball.catchable = false
            mrDo.hasBall = true
            mrDo.animate()
        }
    }
    
    func throwBall(){
        guard mrDo.hasBall else { return }
        if mrDo.facing == .right {
            ball.setPosition(xPos: mrDo.xPos, yPos: mrDo.yPos,ballDirection: .downright)
        } else
        if mrDo.facing == .left {
            ball.setPosition(xPos: mrDo.xPos, yPos: mrDo.yPos,ballDirection: .downleft)
        } else
        if mrDo.facing == .up {
            ball.setPosition(xPos: mrDo.xPos, yPos: mrDo.yPos,ballDirection: .upright)
        } else
        if mrDo.facing == .down {
            ball.setPosition(xPos: mrDo.xPos, yPos: mrDo.yPos,ballDirection: .downleft)
        }
        ball.thrown = true
        mrDo.hasBall = false
        mrDo.animate()
    }
    
    func circlesIntersect(center1: CGPoint, diameter1: CGFloat, center2: CGPoint, diameter2: CGFloat) -> Bool {
        let radius1 = diameter1 / 2
        let radius2 = diameter2 / 2
        let distanceX = center2.x - center1.x
        let distanceY = center2.y - center1.y
        let distanceSquared = distanceX * distanceX + distanceY * distanceY
        let radiusSum = radius1 + radius2
        let radiusSumSquared = radiusSum * radiusSum
        return distanceSquared <= radiusSumSquared
    }
}
