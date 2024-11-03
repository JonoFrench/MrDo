//
//  GameManager.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import QuartzCore
import SwiftUI
import Combine

@MainActor
final class GameManager: ObservableObject {
    // MARK: - Published Properties
    @Published var gameState: GameState = .intro
    @Published var lives = GameConstants.Game.initialLives
    @Published var score = 0
    @Published var extraCollected: [Bool] = []
    @Published var extraCurrent = 0 {
        didSet {
            if extraCurrent == GameConstants.Game.extraLifeLetters {
                extraCurrent = 0
            }
        }
    }
    @Published var extraLifeFlashOn = true
    @Published var points: Points?
    
    // MARK: - Game Objects
    let hiScores: MrDoHighScores = MrDoHighScores()
    @Published var screenData: ScreenData = ScreenData()
    // MARK: - Assets
    var extraFrames: [UIImage] = []
    
    // MARK: - Sprites
    @ObservedObject private(set) var mrDo: MrDo = MrDo()
    @ObservedObject private(set) var appleArray: AppleArray = AppleArray()
    @ObservedObject private(set) var redMonsterArray: RedMonsterArray = RedMonsterArray()
    @ObservedObject private(set) var extraMonsterArray: ExtraMonsterArray = ExtraMonsterArray()
    @ObservedObject private(set) var ball: Ball = Ball()
    @ObservedObject private(set) var progress: Progress = Progress()
    @ObservedObject private(set) var extraLife: ExtraLife = ExtraLife()
    
    // MARK: - Game State
    var levelScore = 0
    var cherryCount = 0
    var gameTime = 0
    var chaseMode = false
    var center: Center = Center()
    var levelScores: [LevelScores] = []
    var startTime: Date = Date()
    var endTime: Date = Date()
    var extraAppearing = false
    var introBall = false
    var introLetter = 0
    
    // MARK: - Movement
    var moveDirection: JoyPad = .stop {
        didSet {
            if moveDirection != oldValue {
                handleJoyPad()
            }
        }
    }
    
    // MARK: - Debug
    var turnOffCollisions = false
    
    // MARK: - Check Counter
    var checkCounter: Int = 0 {
        didSet {
            if checkCounter > 4 {
                checkCounter = 0
            }
        }
    }
    
    init() {
        setupSharedServices()
        setNotificationObservers()
        setExtraFrames()
        setupDisplayLink()
    }
    
    /// Share these instances so they are available from the other Sprites
    private func setupSharedServices() {
        ServiceLocator.shared.register(service: screenData)
        ServiceLocator.shared.register(service: appleArray)
        ServiceLocator.shared.register(service: mrDo)
        ServiceLocator.shared.register(service: redMonsterArray)
        ServiceLocator.shared.register(service: extraMonsterArray)
    }
    
    private func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshModel))
        displayLink.add(to: .main, forMode: .common)
    }
    
    func setInit() {
#if os(iOS)
        screenData.assetDimension = screenData.gameSize.width / Double(screenData.screenDimensionX)
#elseif os(tvOS)
        screenData.assetDimension = screenData.gameSize.height / 14 //Double(screenData.screenDimensionX + 3)
#endif
        //        print("Asset dim \(screenData.assetDimension) width should be \(screenData.assetDimension * 12)")
        screenData.assetDimensionStep = screenData.assetDimension / GameConstants.Speed.tileSteps
        setIntroScreenData()
    }
    
    func startGame() {
        lives = GameConstants.Game.initialLives
        score = 0
        gameTime = 0
        screenData.level = 1
        screenData.gameLevel = 1
        screenData.gameOver = false
        cherryCount = 0
        extraCollected = Array(repeating: false, count: GameConstants.Game.extraLifeLetters)
        
        ///Testing stuff
        turnOffCollisions = true
        
        /// Comment out startPlaying to test these
        
        ///Testing Progess screen.
        //        progress = Progress()
        //        levelScores.append(LevelScores(level: 1, time: Int(45),levelScore: 1000,endType: .cherry))
        //        levelScores.append(LevelScores(level: 2, time: Int(83),levelScore: 2500,endType: .redmonster))
        //        levelScores.append(LevelScores(level: 10, time: Int(96),levelScore: 4600,endType: .redmonster))
        //        gameState = .progress
        //        gameScreen.soundFX.progressSound()
        /// Testing Progress10
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
    
    private func handleJoyPad() {
        guard gameState == .playing else { return }
        switch moveDirection {
        case .down: mrDo.direction = .down
        case .left: mrDo.direction = .left
        case .right: mrDo.direction = .right
        case .up: mrDo.direction = .up
        case .stop: mrDo.willStop = true
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
            extraLifeHandling()
        } else if gameState == .intro {
            introHandling()
        }
    }
    
    func startPlaying() {
        extraLifeFlashOn = true
        screenData.levelEnd = false
        screenData.gameOver = false
        extraCurrent = 0
        extraAppearing = false
        chaseMode = false
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        levelScore = 0
        setDataForLevel(level: screenData.level)
        startTime = Date()
        gameState = .playing
        screenData.soundFX.startSound()
        extraHeader()
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.monsterSpawnDelay))
            screenData.soundFX.backgroundSound()
            addRedMonsters()
        }
    }
    
    func restartPlaying(){
        mrDo.reset()
        moveDirection = .stop
        gameState = .playing
        screenData.soundFX.startSound()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.monsterSpawnDelay))
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
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.levelEndDelay))
            mrDo.reset()
            ball.reset()
            checkEXTRA()
        }
    }
    
    private func checkEXTRA(){
        /// Check if we have all EXTRA for extra life.
        if extraCollected.filter({$0 == true}).count == GameConstants.Game.extraLifeLetters {
            extraLife = ExtraLife()
            gameState = .extralife
            screenData.soundFX.extraLifeSound()
            extraFlash()
        } else {
            checkNextLevel()
        }
    }
    
    func checkNextLevel() {
        if screenData.level % 3 == 0 {
            ///Every 3 levels display the how we doing screen.
            progress = Progress()
            gameState = .progress
            screenData.soundFX.progressSound()
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(GameConstants.Delay.showNextLevelDelay))
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
    
    private func introBallHandling(){
        if ball.thrown {
            checkBallHitIntroMonster()
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
        if circlesIntersect(center1: mrDo.position, diameter1: mrDo.frameSize.width / 2, center2: center.position, diameter2: center.frameSize.width / 2) && center.collectible {
            let val = center.collectBonusFood()
            score += val
            levelScore += val
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
    
    func extraLifeHandling() {
        extraLife.move()
        extraLife.animate()
        if extraLife.ball.exploding {
            extraLife.ball.explode()
        } else
        if extraLife.ball.imploding {
            extraLife.ball.implode()
        }
    }
    
    func introHandling() {
        monsterHandling()
        if !extraMonsterArray.monsters.isEmpty {
            if !introBall && !ball.thrown && extraMonsterArray.monsters[0].xPos == 4 {
                throwBall()
                introBall = true
            }
        }
        introBallHandling()
    }
    
    private func addExtraMonsters(){
        guard extraMonsterArray.monsterCount < 6 else {
            return
        }
        extraMonsterArray.add(xPos: 6, yPos: 0,letterPos: extraCurrent)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.extraMonsterSpawnDelay))
            addExtraMonsters()
        }
    }
    
    private func addRedMonsters(){
        guard redMonsterArray.monsterCount < 6 else {
            return
        }
        redMonsterArray.add(xPos: 5, yPos: 6)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.monsterSpawnDelay))
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
                    killLetter()
                }
                return
            }
        }
    }
    
    private func checkBallHitIntroMonster() {
        for monster in extraMonsterArray.monsters where monster.monsterState == .moving || monster.monsterState == .chasing || monster.monsterState == .still {
            if circlesIntersect(center1: ball.position, diameter1: ball.frameSize.width / 2, center2: monster.position, diameter2: monster.frameSize.width / 2 ){
                ball.setExplode(position: monster.position)
                returnBall()
                monster.kill()
                appleArray.add(xPos: monster.xPos, yPos: monster.yPos)
                return
            }
        }
    }
    
    func killLetter() {
        guard gameState == .playing else { return }
        extraCollected[extraCurrent] = true
        extrasToApples()
        screenData.levelData.resetExtraLevelData(level: screenData.level)
        redMonsterArray.moving()
        screenData.soundFX.backgroundAlphaSoundStop()
        screenData.soundFX.backgroundFastSound()
        
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
        if gameState == .intro {
            ball.setImplode(position: mrDo.position)
            return
        }
        if center.collected && gameState == .playing {
            ball.setImplode(position: mrDo.position)
            screenData.soundFX.ballResetSound()
        } else {
            Task { @MainActor in
                let timeAdjust = Double(redMonsterArray.killCount) * 0.5
                try? await Task.sleep(for: .seconds(GameConstants.Delay.returnBallDelay + timeAdjust))
                if gameState == .playing {
                    ball.setImplode(position: mrDo.position)
                    screenData.soundFX.ballResetSound()
                }
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
