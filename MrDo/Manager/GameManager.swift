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
    case intro,playing,ended,highscore,levelend,progress,progress10,extralife
}

enum JoyPad {
    case left,right,up,down,stop
}

enum LevelEndType {
    case cherry,redmonster,extramonster
}

//struct GameConstants {
//    static let tileSteps = 8.0
//    static let doSpeed = 2
//    static let ballSpeed = 2
//    static let monsterSpeed = 4
//#if os(iOS)
//    static var doSize = CGSize(width: 32, height: 32)
//   static var startText = "PRESS JUMP TO START"
//#elseif os(tvOS)
//    static var doSize = CGSize(width: 64, height: 64)
//    static var startText = "PRESS A TO START"
//#endif
//}

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
    var screenData:ScreenData = ScreenData()
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
    var mrDo:MrDo = MrDo(xPos: 0, yPos: 0, frameSize: GameConstants.Size.doSize)
    @ObservedObject
    var appleArray:AppleArray = AppleArray()
    @ObservedObject
    var redMonsterArray:RedMonsterArray = RedMonsterArray()
    @ObservedObject
    var extraMonsterArray:ExtraMonsterArray = ExtraMonsterArray()

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

    /// For the EXTRA at the top of the screen.
    var extraFrames: [UIImage] = []
    @Published
    var extraCollected:[Bool] = [false,false,false,false,false]
    @Published
    var extraCurrent = 0 {
        didSet {
            if extraCurrent == 5 {
                extraCurrent = 0
            }
        }
    }
    var extraAppearing = false
    
    @ObservedObject
    var progress:Progress = Progress()
    @ObservedObject
    var extraLife:ExtraLife = ExtraLife()
    @Published
    var extraLifeFlashOn = true
    @Published
    var points:Points?
    var chaseMode = false
    init() {
        moveDirection = .stop
        /// Share these instances so they are available from the other Sprites
        ServiceLocator.shared.register(service: screenData)
        ServiceLocator.shared.register(service: appleArray)
        ServiceLocator.shared.register(service: mrDo)
        ServiceLocator.shared.register(service: redMonsterArray)
        ServiceLocator.shared.register(service: extraMonsterArray)
        ///Here we go, lets have a nice DisplayLink to update our model with the screen refresh.
        let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(refreshModel))
        displayLink.add(to: .main, forMode:.common)
        notificationObservers()
        setExtraFrames()
    }
    
    func startGame() {
#if os(iOS)
        screenData.assetDimension = screenData.gameSize.width / Double(screenData.screenDimensionX)
#elseif os(tvOS)
        gameScreen.assetDimension = gameScreen.gameSize.height / 14 //Double(gameScreen.screenDimensionX + 3)
#endif
print("Asset dim \(screenData.assetDimension) width should be \(screenData.assetDimension * 12)")
        screenData.assetDimensionStep = screenData.assetDimension / GameConstants.Speed.tileSteps
        lives = 3
        score = 0
        gameTime = 0
        screenData.level = 1
        screenData.gameLevel = 1
        screenData.gameOver = false
        cherryCount = 0
        ///Testing stuff
        
//        turnOffCollisions = true
        
        
        ///Testing Progess screen.
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
        
        ///Testing Extra screen
//        extraCollected = [true,true,true,true,true]
//        gameScreen.soundFX.extraLifeSound()
//        extraLife = ExtraLife()
//        gameState = .extralife
//        extraFlash()
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
            doHandling()
            ballHandling()
            appleHandling()
            monsterHandling()
        } else if gameState == .progress {
                progress.move()
        } else if gameState == .ended {
            
        } else if gameState == .extralife {
            extraLife.move()
            extraLife.animate()
            if extraLife.ball.exploding {
                extraLife.ball.explode()
            } else
            if extraLife.ball.imploding {
                extraLife.ball.implode()
            }
        }
    }
    
    func startPlaying() {
        extraLifeFlashOn = true
        screenData.pause = false
        screenData.levelEnd = false
        screenData.gameOver = false
        extraCurrent = 0
        extraAppearing = false
        extraCollected = [false,false,false,false,false]
        chaseMode = false
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        levelScore = 0
        setDataForLevel(level: screenData.level)
        startTime = Date()
        gameState = .playing
        screenData.soundFX.startSound()
        extraHeader()
        DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.Delay.monsterSpawnDelay) { [self] in
            screenData.soundFX.backgroundSound()
            addRedMonsters()
        }
    }
    
    func restartPlaying(){
        mrDo.reset()
        moveDirection = .stop
        gameState = .playing
        screenData.soundFX.startSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.Delay.monsterSpawnDelay) { [self] in
            screenData.soundFX.backgroundSound()
            redMonsterArray.moving()
            extraMonsterArray.moving()
        }
    }
    
    func nextLevel(endType:LevelEndType) {
        screenData.soundFX.backgroundStopAll()
        screenData.soundFX.roundClear()
        endTime = Date()
        let difference = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        gameTime += Int(difference)
        levelScores.append(LevelScores(level: screenData.level, time: Int(difference),levelScore: levelScore,endType: endType))
        cherryCount = 0
        redMonsterArray.monsterCount = 0
        redMonsterArray.killCount = 0
        extraMonsterArray.monsterCount = 0
        extraMonsterArray.killCount = 0
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        extraMonsterArray.letterAdded = false
        gameState = .levelend
        chaseMode = false
        center.collected = false
        DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.Delay.levelEndDelay) { [self] in
            mrDo.reset()
            ball.reset()
            
            /// Check if we have all EXTRA for extra life.
            if extraCollected.filter({$0 == true}).count == 5 {
                extraLife = ExtraLife()
                gameState = .extralife
                screenData.soundFX.extraLifeSound()
                extraFlash()
            } else {
                checkNextLevel()
            }
        }
    }
    
    func checkNextLevel() {
        if screenData.level % 3 == 0 {
        ///Every 3 levels display the how we doing screen.
        progress = Progress()
        gameState = .progress
        screenData.soundFX.progressSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.Delay.showNextLevelDelay) { [self] in
            screenData.level += 1
            screenData.gameLevel += 1
            startPlaying()
        }
    } else {
        if screenData.level % 10 == 0 {
            progress10()
        } else {
            screenData.level += 1
            screenData.gameLevel += 1
            startPlaying()
        }
    }
    }
    private func ballHandling(){
        if ball.thrown {
            catchBall()
            checkBallHitRedMonsters()
            checkBallHitExtraMonsters()
            ball.move()
        } else
        if ball.exploding {
            ball.explode()
        } else
        if ball.imploding {
            ball.implode()
        }
    }
    
    private func appleHandling() {
        appleArray.checkDrop(doXpos: mrDo.xPos,doYpos: mrDo.yPos)
        appleArray.move()
     }
    
    private func monsterHandling() {
        redMonsterArray.move()
        extraMonsterArray.move()
    }
    
    private func doHandling() {
        mrDo.move()
        guard mrDo.doState != .dead && mrDo.doState != .falling else { return}
        /// Collect the bonus food and enter EXTRA mode
        if mrDo.xPos == 5 && mrDo.yPos == 6 && center.collectible == true {
            center.collectBonusFood()
            screenData.levelData.setExtraLevelData()
            screenData.soundFX.backgroundStopAll()
            screenData.soundFX.backgroundAlphaSound()
            redMonsterArray.still()
            extraAppearing = true
            addExtraMonsters()
        }
        ///So we can test everything else!
        if !turnOffCollisions {
            doCaught()
        }
    }
    
    private func addExtraMonsters(){
        guard extraMonsterArray.monsterCount < 6 else {
            return
        }
        extraMonsterArray.add(xPos: 5, yPos: 0,letterPos: extraCurrent)
        DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.Delay.extraMonsterSpawnDelay) { [self] in
            addExtraMonsters()
        }
    }

    private func addRedMonsters(){
        guard redMonsterArray.monsterCount < 6 else {
            return
        }
        redMonsterArray.add(xPos: 5, yPos: 6)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in:0...4) + GameConstants.Delay.monsterSpawnDelay) { [self] in
            addRedMonsters()
            if redMonsterArray.monsterCount == 6 {
                center.setBonusFood(level: screenData.level)
            }
        }
    }
    
    private func checkBallHitRedMonsters() {
        for monster in redMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                ball.setExplode(position: monster.position)
                returnBall()
                points = Points(xPos: monster.xPos, yPos: monster.yPos, value: .fivehundred)
                score += GameConstants.Score.monsterPoints
                levelScore += GameConstants.Score.monsterPoints
                monster.kill()
                screenData.soundFX.ballHitSound()
                return
            }
        }
    }

    private func checkBallHitExtraMonsters() {
        for monster in extraMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                ball.setExplode(position: monster.position)
                returnBall()
                points = Points(xPos: monster.xPos, yPos: monster.yPos, value: .fivehundred)
                score += GameConstants.Score.monsterPoints
                levelScore += GameConstants.Score.monsterPoints
                monster.kill()
                screenData.soundFX.ballHitSound()
                if monster.monsterType == .bluemonster {
                    appleArray.add(xPos: monster.xPos, yPos: monster.yPos)
                } else {
                    extraCollected[extraCurrent] = true
                    extrasToApples()
                    DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.Delay.nextLevelDelay) { [self] in
                        nextLevel(endType: .extramonster)
                    }
                }
                return
            }
        }
    }
    
    private func doCaught() {
        for monster in redMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: mrDo.position, diameter1: mrDo.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ) {
                redMonsterArray.remove(id: monster.id)
                killDo()
                return
            }
        }
        for monster in extraMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: mrDo.position, diameter1: mrDo.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                extraMonsterArray.remove(id: monster.id)
                killDo()
                return
            }
        }
    }
    
    private func killDo() {
        screenData.soundFX.backgroundStopAll()
        redMonsterArray.still()
        extraMonsterArray.still()
        mrDo.killed()
    }
    
    private func extrasToApples() {
        for monster in extraMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            appleArray.add(xPos: monster.xPos, yPos: monster.yPos)
            extraMonsterArray.remove(id: monster.id)
        }
    }
    
    private func catchBall(){
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
    
    private func returnBall(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            if gameState == .playing {
                ball.setImplode(position: mrDo.position)
                screenData.soundFX.ballResetSound()
            }
        }
    }
        
    func levelEndImage(type:LevelEndType) -> ImageResource {
        switch type {
        case .cherry:
            ImageResource(name: "Cherry", bundle: .main)
        case .redmonster:
            ImageResource(name: "RedMonster", bundle: .main)
        case .extramonster:
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
