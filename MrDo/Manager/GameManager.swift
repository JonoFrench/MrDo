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
    
    init() {
        moveDirection = .stop
        /// Share these instances so they are available from the Sprites
        ServiceLocator.shared.register(service: gameScreen)
        ServiceLocator.shared.register(service: appleArray)
        ServiceLocator.shared.register(service: mrDo)
        ServiceLocator.shared.register(service: redMonsterArray)
        ///Here we go, lets have a nice DisplayLink to update our model with the screen refresh.
        let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(refreshModel))
        displayLink.add(to: .main, forMode:.common)
        notificationObservers()
        setExtraFrames()
    }
    
    func setExtraFrames() {
        extraFrames.append(gameScreen.levelData.getTile(name: "ExtraMonsters", pos: 0)!)
        extraFrames.append(gameScreen.levelData.getTile(name: "ExtraMonsters", pos: 3)!)
        extraFrames.append(gameScreen.levelData.getTile(name: "ExtraMonsters", pos: 6)!)
        extraFrames.append(gameScreen.levelData.getTile(name: "ExtraMonsters", pos: 9)!)
        extraFrames.append(gameScreen.levelData.getTile(name: "ExtraMonsters", pos: 12)!)
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
        gameScreen.pause = false
        gameScreen.levelEnd = false
        gameScreen.gameOver = false
        extraCurrent = 0
        extraAppearing = false
        extraCollected = [false,true,false,true,false]
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        levelScore = 0
        setDataForLevel(level: gameScreen.level)
        startTime = Date()
        gameState = .playing
        gameScreen.soundFX.startSound()
        extraHeader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { [self] in
            gameScreen.soundFX.backgroundSound()
            addRedMonsters()
        }
    }
    
    func extraHeader() {
        if gameState == .playing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                extraCurrent += 1
                extraHeader()
            }
        }
    }
    
    func extraFlash() {
        if gameState == .extralife {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                extraLifeFlashOn = !extraLifeFlashOn
                extraFlash()
            }
        } else {
            extraLifeFlashOn = true
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
        gameScreen.soundFX.backgroundStopAll()
        gameScreen.soundFX.roundClear()
        endTime = Date()
        let difference = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        gameTime += Int(difference)
        levelScores.append(LevelScores(level: gameScreen.level, time: Int(difference),levelScore: levelScore,endType: endType))
        cherryCount = 0
        redMonsterArray.monsterCount = 0
        redMonsterArray.killCount = 0
        extraMonsterArray.monsterCount = 0
        extraMonsterArray.killCount = 0
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        extraMonsterArray.letterAdded = false
        gameState = .levelend
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            mrDo.reset()
            ball.reset()
            
            /// Check if we have all EXTRA for extra life.
            if extraCollected.filter({$0 == true}).count == 5 {
                extraLife = ExtraLife()
                gameState = .extralife
                gameScreen.soundFX.extraLifeSound()
                extraFlash()
            } else {
                checkNextLevel()
            }
        }
    }
    
    func checkNextLevel() {
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
        /// Collect the bonus food and enter EXTRA mode
        if mrDo.xPos == 5 && mrDo.yPos == 6 && center.collectible == true {
            center.collectBonusFood()
            gameScreen.levelData.setExtraLevelData()
            gameScreen.soundFX.backgroundStopAll()
            gameScreen.soundFX.backgroundAlphaSound()
            redMonsterArray.still()
            extraAppearing = true
            addExtraMonsters()
        }
    }
    
    private func addExtraMonsters(){
        guard extraMonsterArray.monsterCount < 6 else {
            return
        }
        extraMonsterArray.add(xPos: 5, yPos: 0,letterPos: extraCurrent)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            addExtraMonsters()
        }
    }

    
    private func addRedMonsters(){
        guard redMonsterArray.monsterCount < 6 else {
            return
        }
        redMonsterArray.add(xPos: 5, yPos: 6)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in:0...5) + 2.0) { [self] in
            addRedMonsters()
            if redMonsterArray.monsterCount == 6 {
                center.setBonusFood()
            }
        }
    }
    
    func checkBallHitRedMonsters() {
        for monster in redMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                ball.setExplode(position: monster.position)
                returnBall()
                score += 500
                monster.kill()
                gameScreen.soundFX.ballHitSound()
                return
            }
        }
    }

    func checkBallHitExtraMonsters() {
        for monster in extraMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                ball.setExplode(position: monster.position)
                returnBall()
                score += 500
                monster.kill()
                gameScreen.soundFX.ballHitSound()
                if monster.extraType == .monster {
                    appleArray.add(xPos: monster.xPos, yPos: monster.yPos)
                } else {
                    extraCollected[extraCurrent] = true
                    extrasToApples()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                        nextLevel(endType: .extramonster)
                    }
                }
                return
            }
        }
    }
    
    func extrasToApples() {
        for monster in extraMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            appleArray.add(xPos: monster.xPos, yPos: monster.yPos)
            extraMonsterArray.remove(id: monster.id)
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
            if gameState == .playing {
                ball.setImplode(position: mrDo.position)
                gameScreen.soundFX.ballResetSound()
            }
        }
    }
    
    func progress10(){
        gameState = .progress10
        gameScreen.levelData.setProgress10Data()
        gameScreen.soundFX.backgroundStopAll()
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
