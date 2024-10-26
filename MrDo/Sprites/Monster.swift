//
//  Monster.swift
//  MrDo
//
//  Created by Jonathan French on 23.10.24.
//

import Foundation
import SwiftUI

enum MonsterState {
    case appearing,moving,chasing,dead,digging,still,falling
}

enum MonsterDirection {
    case left,right,up,down
}

class Monster:SwiftUISprite {
    var monsterState:MonsterState = .appearing
    var monsterDirection:MonsterDirection = .down
    var currentSpeed:Int = GameConstants.monsterSpeed
    private var increaseSpeedCounter = 0
    private var upSet:Set = [TileType.bk,.vt,.ll,.lr,.rt,.tl,.tr,.lt]
    private var downSet:Set = [TileType.bk,.vt,.ll,.lr,.rb,.bl,.br,.lb]
    private var leftSet:Set = [TileType.bk,.hz,.lt,.lb,.rl,.tl,.bl,.ll]
    private var rightSet:Set = [TileType.bk,.hz,.lt,.lb,.rr,.tr,.br,.lr]
    lazy var deadFrame: UIImage = UIImage()
    lazy var blankFrame: UIImage = UIImage()

    var rightFrames: [UIImage] = []
    var leftFrames: [UIImage] = []
    var upFrames: [UIImage] = []
    var downFrames: [UIImage] = []

    override init(xPos: Int, yPos: Int, frameSize: CGSize) {
        super.init(xPos: xPos, yPos: yPos, frameSize: frameSize)
        deadFrame = getTile(name: "BlueMonsters", pos: 8)!
        blankFrame = getTile(name: "RedMonsters", pos: 12,y:1)!
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
                print("Move Left \(gridOffsetX)")
                if gridOffsetX == 0 {
                    if !canMoveLeft() {
                        monsterDirection = nextDirection()
                        print("Can't move Left. moving \(monsterDirection)")
                        return
                    }
//                    xPos -= 1
                    let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .left {
                        monsterDirection = rndDirection
                        if monsterDirection == .right {
//                            gridOffsetX = 7
                        }

//                        xPos += 1
                        return
                    } else {
                        gridOffsetX = 7
                        xPos -= 1
                        increaseSpeedCounter += 1
                    }
                } else {
                    gridOffsetX -= 1
                }
                position.x -= moveDistance
                
            case .right:
                print("Move Right \(gridOffsetX)")
                if gridOffsetX == 0 {
                    if !canMoveRight() {
                        monsterDirection = nextDirection()
                        print("Can't move right. moving \(monsterDirection)")
                        if monsterDirection == .left {
//                            gridOffsetX = 7
                        }
                        return
                    }
                }
                if gridOffsetX == 7 {
//                    xPos += 1
                   let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .right {
//                        gridOffsetX = 0
//                        xPos -= 1
                        monsterDirection = rndDirection
                        return
                    } else {
                        gridOffsetX = 0
                        xPos += 1
                        increaseSpeedCounter += 1
                    }
                } else {
                    gridOffsetX += 1
                }
                position.x += moveDistance
                
            case .up:
                print("Move Up \(gridOffsetY)")
                if gridOffsetY == 0 {
                    if !canMoveUp() {
                        monsterDirection = nextDirection()
                        print("Can't move Up. moving \(monsterDirection)")
                        return
                    }
//                    yPos -= 1
                    let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .up {
                        monsterDirection = rndDirection
                        if monsterDirection == .down {
//                            gridOffsetY = 7
                        }
//                        yPos += 1
                        return
                    } else {
                        gridOffsetY = 7
                        yPos -= 1
                        increaseSpeedCounter += 1
                    }
                } else {
                    gridOffsetY -= 1
                }
                position.y -= moveDistance
                
            case .down:
                print("Move Down \(gridOffsetY)")
                if gridOffsetY == 0 {
                    if !canMoveDown() {
                        monsterDirection = nextDirection()
//                        gridOffsetY = 7
                        print("Can't move Down. moving \(monsterDirection)")
                        return
                    }
                }
                if gridOffsetY == 7 {
//                    yPos += 1
                    let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .down {
                        monsterDirection = rndDirection
                        if monsterDirection == .up {
//                            gridOffsetY = 0
                        }
//                        yPos -= 1
                        return
                    } else {
                        gridOffsetY = 0
                        yPos += 1
                        increaseSpeedCounter += 1
                    }
                } else {
                    gridOffsetY += 1
                }
                position.y += moveDistance
            }
        }
    }
    func nextDirection() -> MonsterDirection {
        var directionArray:[MonsterDirection] = []
        if canMoveUp() {directionArray.append(.up)}
        if canMoveDown() {directionArray.append(.down)}
        if canMoveLeft() {directionArray.append(.left)}
        if canMoveRight() {directionArray.append(.right)}
        if monsterState == .chasing {
            if let doInstance: MrDo = ServiceLocator.shared.resolve() {
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
            }
        }
        return directionArray[Int.random(in: 0..<directionArray.count)]
    }
    
    private func canMoveUp() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos > 0 else {
                print("Top Edge")
                return false }
            if checkApple(xPos: xPos, yPos: yPos-1) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos-1][xPos]
            if upSet.contains(checkAsset) {
                print("Can Move Up to X\(xPos) Y\(yPos - 1) \(checkAsset)")
                return true
            }
        }
        return false
    }
    
    private func canMoveDown() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < screenData.screenDimensionY-1 else {
                print("Bottom Edge")
                return false }
            if checkApple(xPos: xPos, yPos: yPos+1) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
            if downSet.contains(checkAsset) {
                print("Can Move Down to X\(xPos) Y\(yPos + 1) \(checkAsset)")
                return true
            }
        }
        return false
    }
    
    private func canMoveLeft() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos > 0 else {
                print("Left Edge")
                return false }
            if checkApple(xPos: xPos-1, yPos: yPos) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos][xPos-1]
            if leftSet.contains(checkAsset) {
                print("Can Move Left to X\(xPos-1) Y\(yPos) \(checkAsset)")
                return true
            }
        }
        return false
    }
    
    private func canMoveRight() -> Bool {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos < screenData.screenDimensionX - 1 else {
                print("Right Edge")
                return false }
            if checkApple(xPos: xPos+1, yPos: yPos) { return false }
            let checkAsset = screenData.levelData.tileArray[yPos][xPos+1]
            if rightSet.contains(checkAsset) {
                print("Can Move Right to X\(xPos+1) Y\(yPos) \(checkAsset)")
                return true
            }
        }
        return false
    }
    
    private func checkApple(xPos:Int,yPos:Int) -> Bool {
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
}
