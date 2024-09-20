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

    @Published
    var appleArray:[Apple] = []
    var center:Center = Center(xPos: 5, yPos: 6)
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
    
    func setDataForLevel() {
        appleArray.removeAll()
        center = Center(xPos: 5, yPos: 6)
        gameScreen.levelData.setLevelData(level: gameScreen.level)
        switch gameScreen.level {
        case 1: level1Data()
        case 2: level2Data()
        case 3: level3Data()
        case 4: level4Data()
        case 5: level5Data()
        case 6: level6Data()
        case 7: level7Data()
        case 8: level8Data()
        case 9: level9Data()
        case 10: level10Data()

        default:
            level1Data()
        }
        
    }
    
    func level1Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 2, yPos: 0))
        appleArray.append(Apple(xPos: 4, yPos: 2))
        appleArray.append(Apple(xPos: 10, yPos: 3))
        appleArray.append(Apple(xPos: 8, yPos: 4))
        appleArray.append(Apple(xPos: 2, yPos: 5))
        appleArray.append(Apple(xPos: 7, yPos: 8))
    }
 
    func level2Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 8, yPos: 1))
        appleArray.append(Apple(xPos: 6, yPos: 2))
        appleArray.append(Apple(xPos: 1, yPos: 3))
        appleArray.append(Apple(xPos: 1, yPos: 3))
        appleArray.append(Apple(xPos: 6, yPos: 3))
        appleArray.append(Apple(xPos: 3, yPos: 4))
        appleArray.append(Apple(xPos: 7, yPos: 8))
    }

    func level3Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 5, yPos: 1))
        appleArray.append(Apple(xPos: 7, yPos: 1))
        appleArray.append(Apple(xPos: 10, yPos: 3))
        appleArray.append(Apple(xPos: 2, yPos: 4))
        appleArray.append(Apple(xPos: 3, yPos: 7))
        appleArray.append(Apple(xPos: 7, yPos: 8))
    }
    
    func level4Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 8, yPos: 1))
        appleArray.append(Apple(xPos: 5, yPos: 2))
        appleArray.append(Apple(xPos: 2, yPos: 3))
        appleArray.append(Apple(xPos: 6, yPos: 4))
        appleArray.append(Apple(xPos: 6, yPos: 5))
        appleArray.append(Apple(xPos: 10, yPos: 7))
    }

    func level5Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 5, yPos: 1))
        appleArray.append(Apple(xPos: 1, yPos: 2))
        appleArray.append(Apple(xPos: 7, yPos: 2))
        appleArray.append(Apple(xPos: 3, yPos: 6))
        appleArray.append(Apple(xPos: 8, yPos: 6))
        appleArray.append(Apple(xPos: 7, yPos: 7))
    }

    func level6Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 5, yPos: 1))
        appleArray.append(Apple(xPos: 8, yPos: 2))
        appleArray.append(Apple(xPos: 1, yPos: 3))
        appleArray.append(Apple(xPos: 9, yPos: 3))
        appleArray.append(Apple(xPos: 3, yPos: 8))
        appleArray.append(Apple(xPos: 9, yPos: 9))
    }
    func level7Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 1, yPos: 1))
        appleArray.append(Apple(xPos: 8, yPos: 1))
        appleArray.append(Apple(xPos: 6, yPos: 2))
        appleArray.append(Apple(xPos: 3, yPos: 3))
        appleArray.append(Apple(xPos: 2, yPos: 7))
        appleArray.append(Apple(xPos: 9, yPos: 8))
    }
    func level8Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 4, yPos: 1))
        appleArray.append(Apple(xPos: 5, yPos: 1))
        appleArray.append(Apple(xPos: 1, yPos: 3))
        appleArray.append(Apple(xPos: 7, yPos: 3))
        appleArray.append(Apple(xPos: 4, yPos: 8))
        appleArray.append(Apple(xPos: 7, yPos: 9))
    }
    func level9Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 4, yPos: 1))
        appleArray.append(Apple(xPos: 2, yPos: 2))
        appleArray.append(Apple(xPos: 4, yPos: 2))
        appleArray.append(Apple(xPos: 9, yPos: 2))
        appleArray.append(Apple(xPos: 8, yPos: 4))
        appleArray.append(Apple(xPos: 4, yPos: 8))
    }
    func level10Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.append(Apple(xPos: 4, yPos: 1))
        appleArray.append(Apple(xPos: 6, yPos: 2))
        appleArray.append(Apple(xPos: 8, yPos: 2))
        appleArray.append(Apple(xPos: 2, yPos: 4))
        appleArray.append(Apple(xPos: 10, yPos: 5))
        appleArray.append(Apple(xPos: 6, yPos: 9))
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
