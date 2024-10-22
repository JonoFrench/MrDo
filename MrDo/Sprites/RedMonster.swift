//
//  RedMonster.swift
//  MrDo
//
//  Created by Jonathan French on 17.10.24.
//

import Foundation
import SwiftUI

enum RedMonsterState {
    case appearing,moving,chasing,dead,digging,still
}

enum MonsterDirection {
    case left,right,up,down
}


final class RedMonsterArray: ObservableObject {
    @Published var monsters: [RedMonster] = []
    var monsterCount = 0
    var killCount = 0
    
    func move() {
        for monster in monsters {
            monster.move()
            monster.animate()
        }
    }
    
    func remove(id:UUID) {
        if let index = monsters.firstIndex(where: {$0.id == id}) {
            monsters.remove(at: index)
            killCount += 1
        }
    }
    
    func add(xPos:Int,yPos:Int) {
        let monster = RedMonster(xPos: xPos, yPos:yPos)
        monsters.append(monster)
        monsterCount += 1
    }
    
}

final class RedMonster:SwiftUISprite,Moveable,Animatable {
    static var animateFrames: Int = 0
    static var speed: Int = GameConstants.monsterSpeed
    
    private var walkRightFrames: [UIImage] = []
    private var walkLeftFrames: [UIImage] = []
    private var walkUpFrames: [UIImage] = []
    private var walkDownFrames: [UIImage] = []
    
    private var chaseRightFrames: [UIImage] = []
    private var chaseLeftFrames: [UIImage] = []
    private var chaseUpFrames: [UIImage] = []
    private var chaseDownFrames: [UIImage] = []
    
    private var deadFrame: UIImage = UIImage()
    private var blankFrame: UIImage = UIImage()
    
    var monsterState:RedMonsterState = .appearing
    private var monsterDirection:MonsterDirection = .down
    private var appearCount = 0
    
    private var upSet:Set = [TileType.bk,.vt,.ll,.lr,.rt,.tl,.tr,.lt]
    private var downSet:Set = [TileType.bk,.vt,.ll,.lr,.rb,.bl,.br,.lb]
    private var leftSet:Set = [TileType.bk,.hz,.lt,.lb,.rl,.tl,.bl,.ll]
    private var rightSet:Set = [TileType.bk,.hz,.lt,.lb,.rr,.tr,.br,.lr]
    
    private var currentSpeed = speed
    private var actualAnimationFrame = 0
    private var increaseSpeedCounter = 0
    
    init(xPos: Int, yPos: Int) {
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 28, height:  28))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 52, height:  52))
#endif
        setImages()
        currentImage = walkRightFrames[0]
        actualAnimationFrame = 0
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = resolvedInstance.assetDimensionStep
        }
        gridOffsetY = 0
    }
    
    func kill(){
        currentImage = UIImage(resource: ImageResource(name: "Points500", bundle: .main))
        monsterState = .dead
    }
    
    func move() {
        guard monsterState != .appearing && monsterState != .dead else { return }
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
                    xPos -= 1
                    let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .left {
                        monsterDirection = rndDirection
                        if monsterDirection == .right {
//                            gridOffsetX = 7
                        }

                        xPos += 1
                        return
                    } else {
                        gridOffsetX = 7
//                        xPos -= 1
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
                    xPos += 1
                   let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .right {
//                        gridOffsetX = 0
                        xPos -= 1
                        monsterDirection = rndDirection
                        return
                    } else {
                        gridOffsetX = 0
//                        xPos += 1
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
                    yPos -= 1
                    let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .up {
                        monsterDirection = rndDirection
                        if monsterDirection == .down {
//                            gridOffsetY = 7
                        }
                        yPos += 1
                        return
                    } else {
                        gridOffsetY = 7
//                        yPos -= 1
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
                    yPos += 1
                    let rndDirection = nextDirection()
                    if Int.random(in: 0...6) == 1 && rndDirection != .down {
                        monsterDirection = rndDirection
                        if monsterDirection == .up {
//                            gridOffsetY = 0
                        }
                        yPos -= 1
                        return
                    } else {
                        gridOffsetY = 0
//                        yPos += 1
                        increaseSpeedCounter += 1
                    }
                } else {
                    gridOffsetY += 1
                }
                position.y += moveDistance
            }
        }
    }
    
    func animate() {
        guard monsterState != .dead else { return }
        currentAnimationFrame += 1
        if currentAnimationFrame == 8 {
            currentAnimationFrame = 0
            if monsterState == .appearing {
                currentImage = appearCount % 2 == 0 ? walkRightFrames[0] : blankFrame
                appearCount += 1
                if appearCount == 13 {
                    monsterState = .moving
                    monsterDirection = nextDirection()
                }
            } else if monsterState == .moving {
                switch monsterDirection {
                case .left:
                    currentImage = walkLeftFrames[actualAnimationFrame]
                case .right:
                    currentImage = walkRightFrames[actualAnimationFrame]
                case .up:
                    currentImage = walkUpFrames[actualAnimationFrame]
                case .down:
                    currentImage = walkDownFrames[actualAnimationFrame]
                }
                actualAnimationFrame += 1
                if actualAnimationFrame == 3 {
                    actualAnimationFrame = 0
                }
                
            } else if monsterState == .still {
                
            }
        }
    }
    
    private func setImages() {
        for i in 0..<3 {
            walkRightFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 3..<6 {
            walkDownFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 6..<9 {
            walkLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 9..<12 {
            walkUpFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 0..<3 {
            chaseRightFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 3..<6 {
            chaseDownFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 6..<9 {
            chaseLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 9..<12 {
            chaseUpFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        deadFrame = getTile(name: "RedMonsters", pos: 12,y:0)!
        blankFrame = getTile(name: "RedMonsters", pos: 12,y:1)!
    }
    
    private func nextDirection() -> MonsterDirection {
        var directionArray:[MonsterDirection] = []
        if canMoveUp() {directionArray.append(.up)}
        if canMoveDown() {directionArray.append(.down)}
        if canMoveLeft() {directionArray.append(.left)}
        if canMoveRight() {directionArray.append(.right)}
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
