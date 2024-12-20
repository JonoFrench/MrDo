//
//  Monster.swift
//  MrDo
//
//  Created by Jonathan French on 23.10.24.
//

import Foundation
import SwiftUI

enum MonsterState {
    case appearing,moving,chasing,dead,digging,still,falling,swallowing
}

enum MonsterDirection {
    case left,right,up,down
}

enum MonsterType {
    case letter,redmonster,bluemonster,swallowmonster,digmonster
}

class Monster:SwiftUISprite {
    var monsterState:MonsterState = .appearing
    var monsterDirection:MonsterDirection = .down
    var currentSpeed:Int = GameConstants.Speed.monsterSpeed
    var actualAnimationFrame = 0
    private var increaseSpeedCounter = 0
    private let upSet:Set = [TileType.bk,.vt,.ll,.lr,.rt,.tl,.tr,.lt]
    private let downSet:Set = [TileType.bk,.vt,.ll,.lr,.rb,.bl,.br,.lb]
    private let leftSet:Set = [TileType.bk,.hz,.lt,.lb,.rl,.tl,.bl,.ll]
    private let rightSet:Set = [TileType.bk,.hz,.lt,.lb,.rr,.tr,.br,.lr]
    lazy var stripeRightFrames: [UIImage] = []
    lazy var stripeLeftFrames: [UIImage] = []
    lazy var stripeUpFrames: [UIImage] = []
    lazy var stripeDownFrames: [UIImage] = []
    lazy var swallowFrames: [UIImage] = []
    lazy var extraSwallowFrames: [UIImage] = []

    lazy var deadFrame: UIImage = UIImage()
    lazy var blankFrame: UIImage = UIImage()
    
    var rightFrames: [UIImage] = []
    var leftFrames: [UIImage] = []
    var upFrames: [UIImage] = []
    var downFrames: [UIImage] = []
    
    var monsterType:MonsterType = .bluemonster
    lazy var prevMonsterType:MonsterType = .bluemonster
    var swallowedApple: Apple?
    var animationSpeed = 8
    var stayDigging = false
    var upDownCount = 0
    var leftRightCount = 0
    
    override init(xPos: Int, yPos: Int, frameSize: CGSize) {
        super.init(xPos: xPos, yPos: yPos, frameSize: frameSize)
        deadFrame = getTile(name: "BlueMonsters", pos: 8)!
        blankFrame = getTile(name: "RedMonsters", pos: 12,y:1)!
    }
    
    ///Set the initial offsets depending on direction.
    func setOffsets(direction:MonsterDirection){
        switch direction {
        case .left: gridOffsetX = 0
        case .right: gridOffsetX = 7
        case .up: gridOffsetY = 0
        case .down: gridOffsetY = 7
        }
    }
    
    func monsterMove(){
        speedCounter += 1
        if speedCounter == currentSpeed {
            speedCounter = 0
            if increaseSpeedCounter == 20 {
                currentSpeed -= 1
                if currentSpeed < 2 {
                    currentSpeed = 2
                }
                increaseSpeedCounter = 0
            }
            switch monsterDirection {
            case .left:
                if gridOffsetX == 0 {
                    if !canMoveLeft() {
                        monsterDirection = nextDirection()
                        return
                    }
                    let rndDirection = nextDirection()
                    if (Int.random(in: 0...6) == 1 && rndDirection != .left) || monsterType == .digmonster {
                        monsterDirection = rndDirection
                        return
                    } else {
                        leftRightCount += 1
                        upDownCount = 0
                        gridOffsetX = 7
                        xPos -= 1
                        increaseSpeedCounter += 1
                        checkSwallowApple()
                    }
                } else { gridOffsetX -= 1 }
                position.x -= moveDistance
                
            case .right:
                if gridOffsetX == 7 {
                    if !canMoveRight() {
                        monsterDirection = nextDirection()
                        return
                    }
                    let rndDirection = nextDirection()
                    if (Int.random(in: 0...6) == 1 && rndDirection != .right) || monsterType == .digmonster  {
                        monsterDirection = rndDirection
                        return
                    } else {
                        leftRightCount += 1
                        upDownCount = 0
                        gridOffsetX = 0
                        xPos += 1
                        increaseSpeedCounter += 1
                        checkSwallowApple()
                    }
                } else { gridOffsetX += 1 }
                position.x += moveDistance
                
            case .up:
                if gridOffsetY == 0 {
                    if !canMoveUp() {
                        monsterDirection = nextDirection()
                        return
                    }
                    let rndDirection = nextDirection()
                    if (Int.random(in: 0...6) == 1 && rndDirection != .up) || monsterType == .digmonster {
                        monsterDirection = rndDirection
                        return
                    } else {
                        leftRightCount = 0
                        upDownCount += 1
                        gridOffsetY = 7
                        yPos -= 1
                        increaseSpeedCounter += 1
                        checkSwallowApple()
                    }
                } else { gridOffsetY -= 1 }
                position.y -= moveDistance
                
            case .down:
                if gridOffsetY == 7 {
                    if !canMoveDown() {
                        monsterDirection = nextDirection()
                        return
                    }
                    let rndDirection = nextDirection()
                    if (Int.random(in: 0...6) == 1 && rndDirection != .down) || monsterType == .digmonster  {
                        monsterDirection = rndDirection
                        return
                    } else {
                        leftRightCount = 0
                        upDownCount += 1
                        gridOffsetY = 0
                        yPos += 1
                        increaseSpeedCounter += 1
                        checkSwallowApple()
                    }
                } else { gridOffsetY += 1 }
                position.y += moveDistance
            }
        }
    }
    
    private func digMode(){
        leftFrames = stripeLeftFrames
        rightFrames = stripeRightFrames
        upFrames = stripeUpFrames
        downFrames = stripeDownFrames
        currentSpeed = GameConstants.Speed.digSpeed
        monsterType = .digmonster
    }
    
    func nextDirection() -> MonsterDirection {
        var directionArray:[MonsterDirection] = []
        if canMoveUp() {directionArray.append(.up)}
        if canMoveDown() {directionArray.append(.down)}
        if canMoveLeft() {directionArray.append(.left)}
        if canMoveRight() {directionArray.append(.right)}
        if let doInstance: MrDo = ServiceLocator.shared.resolve() {
            if monsterState == .chasing {
                /// Dig mode?
                if !canMoveLeft() && doInstance.yPos == yPos && doInstance.xPos < xPos && !checkApple(xPos: xPos-1, yPos: yPos) {
                    digMode()
                    setOffsets(direction: .left)
                    return .left
                }
                if !canMoveRight() && doInstance.yPos == yPos && doInstance.xPos > xPos && !checkApple(xPos: xPos+1, yPos: yPos) {
                    digMode()
                    setOffsets(direction: .right)
                    return .right
                }
                if !canMoveDown() && doInstance.yPos > yPos && doInstance.xPos == xPos && !checkApple(xPos: xPos, yPos: yPos+1){
                    digMode()
                    setOffsets(direction: .down)
                    return .down
                }
                if !canMoveUp() && doInstance.yPos < yPos && doInstance.xPos == xPos && !checkApple(xPos: xPos, yPos: yPos-1) {
                    digMode()
                    setOffsets(direction: .up)
                    return .up
                }
            }
            /// Other direction?
            if directionArray.contains(.up) && doInstance.yPos < yPos {
                directionArray.append(.up)
            }
            if directionArray.contains(.down) && doInstance.yPos > yPos {
                directionArray.append(.down)
            }
            if directionArray.contains(.left) && doInstance.xPos < xPos {
                directionArray.append(.left)
            }
            if directionArray.contains(.right) && doInstance.xPos > xPos {
                directionArray.append(.right)
            }
            
            if directionArray.contains(.up) && doInstance.xPos == xPos && doInstance.yPos < yPos {
                directionArray.append(.up)
                directionArray.append(.up)
            }
            if directionArray.contains(.down) && doInstance.xPos == xPos && doInstance.yPos > yPos {
                directionArray.append(.down)
                directionArray.append(.down)
            }
            if directionArray.contains(.left) && doInstance.yPos == yPos  && doInstance.xPos < xPos{
                directionArray.append(.left)
                directionArray.append(.left)
            }
            if directionArray.contains(.right) && doInstance.yPos == yPos  && doInstance.xPos > xPos{
                directionArray.append(.right)
                directionArray.append(.right)
            }
            
            if directionArray.contains(.right) && upDownCount > 6 {
                directionArray.append(.right)
                directionArray.append(.right)
                directionArray.append(.right)
                directionArray.append(.right)
            }
            if directionArray.contains(.left) && upDownCount > 6 {
                directionArray.append(.left)
                directionArray.append(.left)
                directionArray.append(.left)
                directionArray.append(.left)
            }

            if directionArray.contains(.up) && leftRightCount > 6 {
                directionArray.append(.up)
                directionArray.append(.up)
                directionArray.append(.up)
                directionArray.append(.up)
            }
            if directionArray.contains(.down) && leftRightCount > 6 {
                directionArray.append(.down)
                directionArray.append(.down)
                directionArray.append(.down)
                directionArray.append(.down)
            }
        }
        /// If Digger gets stuck, usually between 2 apples then we can escape by going up or down.
        if directionArray.isEmpty {
            if monsterDirection == .left || monsterDirection == .right {
                directionArray.append(.up)
                directionArray.append(.down)
                stayDigging = true
            }
        }
        let newDir = directionArray[Int.random(in: 0..<directionArray.count)]
        setOffsets(direction: newDir)
        return newDir
    }
    
    func canMoveUp() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos > 0 else { return false }
            if checkApple(xPos: xPos, yPos: yPos-1) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos-1][xPos]
            if upSet.contains(checkAsset) {
                return true
            }
        }
        return false
    }
    
    func canMoveDown() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < screenData.screenDimensionY-1 else { return false }
            if checkApple(xPos: xPos, yPos: yPos+1) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
            if downSet.contains(checkAsset) {
                return true
            }
        }
        return false
    }
    
    func canMoveLeft() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos > 0 else { return false }
            if checkApple(xPos: xPos-1, yPos: yPos) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos][xPos-1]
            if leftSet.contains(checkAsset) {
                return true
            }
        }
        return false
    }
    
    func canMoveRight() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos < screenData.screenDimensionX - 1 else { return false }
            if checkApple(xPos: xPos+1, yPos: yPos) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos][xPos+1]
            if rightSet.contains(checkAsset) {
                return true
            }
        }
        return false
    }
    
    func checkApple(xPos:Int,yPos:Int) -> Bool {
        guard monsterType != .bluemonster && monsterType != .letter else { return false }
        ///Is there an apple?
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.xPos == xPos && apple.yPos == yPos {
                    return true
                }
            }
        }
        return false
    }
    func checkSwallowApple() {
        ///Is there an apple?
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.xPos == xPos && apple.yPos == yPos {
                    swallowedApple = apple
                    swallowedApple?.frameSize = GameConstants.Size.appleSwallowSize
                    setSwallowMonster()
                }
            }
        }
    }
    
    private func setSwallowMonster() {
        prevMonsterType = monsterType
        switch monsterDirection {
        case .left: currentImage = monsterType == .letter ? extraSwallowFrames[2] : swallowFrames[2]
        case .right: currentImage = monsterType == .letter ? extraSwallowFrames[0] : swallowFrames[0]
        case .up: currentImage = monsterType == .letter ? extraSwallowFrames[3] : swallowFrames[3]
        case .down:currentImage = monsterType == .letter ? extraSwallowFrames[1] : swallowFrames[1]
        }
        monsterType = .swallowmonster
        actualAnimationFrame = 0
        currentAnimationFrame = 0
        currentSpeed = GameConstants.Speed.swallowSpeed
        animationSpeed = GameConstants.Speed.swallowAnimation
    }
}
