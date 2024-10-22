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
    case intro,playing,ended,highscore,levelend,progress,progress10
}

enum JoyPad {
    case left,right,up,down,stop
}

enum LevelEndType {
    case cherry,redmonster
}

struct GameConstants {
    static let tileSteps = 8.0
    static let doSpeed = 2
    static let ballSpeed = 2
    static let monsterSpeed = 4

    
#if os(iOS)
    static var doSize = CGSize(width: 32, height: 32)
   static var startText = "PRESS JUMP TO START"
#elseif os(tvOS)
    static var doSize = CGSize(width: 64, height: 64)
    static var startText = "PRESS A TO START"
#endif
}

struct LevelScores {
    let id = UUID()
    var level = 0
    var time = 0
    var levelScore = 0
    var endType:LevelEndType
}

class GameManager: ObservableObject {
    let hiScores:MrDoHighScores = MrDoHighScores()
    @Published
    var gameScreen:ScreenData = ScreenData()
    @Published
    var gameState:GameState = .intro
    @Published
    var lives = 3
    @Published
    var score = 0
    var levelScore = 0
    var cherryCount = 0
    var gameTime = 0
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
    @ObservedObject
    var redMonsterArray:RedMonsterArray = RedMonsterArray()
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
    
    var levelScores:[LevelScores] = []
    var startTime: Date = Date()
    var endTime: Date = Date()

    @ObservedObject
    var progress:Progress = Progress()
    
    init() {
        moveDirection = .stop
        /// Share these instances so they are available from the Sprites
        ServiceLocator.shared.register(service: gameScreen)
        ServiceLocator.shared.register(service: appleArray)
        ServiceLocator.shared.register(service: mrDo)
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
        gameTime = 0
        gameScreen.level = 1
        gameScreen.gameLevel = 1
        gameScreen.gameOver = false
        cherryCount = 0
//        turnOffCollisions = true
        
//        progress = Progress()
//        levelScores.append(LevelScores(level: 1, time: Int(45),levelScore: 1000,endType: .cherry))
//        levelScores.append(LevelScores(level: 2, time: Int(83),levelScore: 2500,endType: .redmonster))
//        levelScores.append(LevelScores(level: 10, time: Int(96),levelScore: 4600,endType: .redmonster))
//        gameState = .progress
//        gameScreen.soundFX.progressSound()
//        gameScreen.level = 10
//        gameScreen.gameLevel = 10
//        gameTime = 450
//        score = 5678
//        progress10()

        startPlaying()
    }
    
    func handleJoyPad() {
//        guard !mrDo.willStop else {return}
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
                checkBallHit()
                ball.move()
            }
            if ball.exploding {
                ball.explode()
            }
            if ball.imploding {
                ball.implode()
            }
            appleArray.checkDrop(doXpos: mrDo.xPos,doYpos: mrDo.yPos)
            if appleArray.move(doXpos: mrDo.xPos,doYpos: mrDo.yPos) {
                mrDo.moveCounter = 7
                mrDo.doState = .falling
            }
            redMonsterArray.move()
        } else if gameState == .progress {
                progress.move()
        } else if gameState == .ended {
            
        }
    }
    
    func startPlaying() {
        gameScreen.pause = false
        gameScreen.levelEnd = false
        gameScreen.gameOver = false
        redMonsterArray.monsters.removeAll()
        levelScore = 0
        setDataForLevel(level: gameScreen.level)
        startTime = Date()
        gameState = .playing
        gameScreen.soundFX.startSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { [self] in
            gameScreen.soundFX.backgroundSound()
            addRedMonsters()
        }
    }
    
    func restartPlaying(){
        mrDo.reset()
        moveDirection = .stop
        gameState = .playing
        gameScreen.soundFX.startSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { [self] in
            gameScreen.soundFX.backgroundSound()
        }
    }
    
    func nextLevel(endType:LevelEndType) {
        gameScreen.soundFX.backgroundSoundStop()
        gameScreen.soundFX.roundClear()
        endTime = Date()
        let difference = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        gameTime += Int(difference)
        levelScores.append(LevelScores(level: gameScreen.level, time: Int(difference),levelScore: levelScore,endType: endType))
        cherryCount = 0
        redMonsterArray.monsterCount = 0
        redMonsterArray.killCount = 0
        redMonsterArray.monsters.removeAll()
        gameState = .levelend
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            mrDo.reset()
            ball.reset()
            if gameScreen.level % 3 == 0 {
                ///Every 3 levels display the how we doing screen.
                progress = Progress()
                gameState = .progress
                gameScreen.soundFX.progressSound()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [self] in
                    gameScreen.level += 1
                    gameScreen.gameLevel += 1
                    startPlaying()
                }
            } else {
                if gameScreen.level % 10 == 0 {
                    progress10()
                } else {
                    gameScreen.level += 1
                    gameScreen.gameLevel += 1
                    startPlaying()
                }
            }
        }
    }
    
    func addRedMonsters(){
        guard redMonsterArray.monsterCount < 6 else {
            center.setBonusFood()
            return
        }
        redMonsterArray.add(xPos: 5, yPos: 6)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in:0...5) + 2.0) { [self] in
            addRedMonsters()
        }
    }
    
    func checkBallHit() {
        for monster in redMonsterArray.monsters where monster.monsterState == .moving {
            if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                ball.setExplode(position: monster.position)
                returnBall()
                score += 500
                monster.kill()
                gameScreen.soundFX.ballHitSound()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    redMonsterArray.remove(id: monster.id)
                    if redMonsterArray.killCount == 5 {
                        nextLevel(endType: .redmonster)
                    }
                }
                return
            }
        }
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
    
    func returnBall(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            ball.setImplode(position: mrDo.position)
            gameScreen.soundFX.ballResetSound()
        }
    }
    
    func progress10(){
        gameState = .progress10
        gameScreen.levelData.setProgress10Data()
        gameScreen.soundFX.backgroundSoundStop()
        gameScreen.soundFX.progressSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [self] in
            gameScreen.level += 1
            gameScreen.gameLevel += 1
            startPlaying()
        }
    }
    
    func levelEndImage(type:LevelEndType) -> ImageResource {
        switch type {
        case .cherry:
            ImageResource(name: "Cherry", bundle: .main)
        case .redmonster:
            ImageResource(name: "RedMonster", bundle: .main)
        }
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
