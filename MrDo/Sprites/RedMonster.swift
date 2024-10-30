//
//  RedMonster.swift
//  MrDo
//
//  Created by Jonathan French on 17.10.24.
//

import Foundation
import SwiftUI

final class RedMonsterArray: ObservableObject {
    @Published var monsters: [RedMonster] = []
    var monsterCount = 0
    var killCount = 0
    var squashCount = 0
    
    func move() {
        for monster in monsters {
            monster.move()
            monster.animate()
        }
    }
    
    func still() {
        for monster in monsters where monster.monsterState == .moving || monster.monsterState == .chasing {
            monster.monsterState = .still
        }
    }

    func moving() {
        for monster in monsters where monster.monsterState == .still {
            monster.monsterState = .moving
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

final class RedMonster:Monster,Moveable,Animatable {
    static var animateFrames: Int = 0
    static var speed: Int = GameConstants.Speed.monsterSpeed
    
    private var walkRightFrames: [UIImage] = []
    private var walkLeftFrames: [UIImage] = []
    private var walkUpFrames: [UIImage] = []
    private var walkDownFrames: [UIImage] = []
    
    private var chaseRightFrames: [UIImage] = []
    private var chaseLeftFrames: [UIImage] = []
    private var chaseUpFrames: [UIImage] = []
    private var chaseDownFrames: [UIImage] = []
    
    private var appearCount = 0
    
    private var actualAnimationFrame = 0
    private var increaseSpeedCounter = 0
    
    init(xPos: Int, yPos: Int) {
        super.init(xPos: xPos, yPos: yPos, frameSize: GameConstants.Size.redMonsterSize)
        setImages()
        currentImage = walkRightFrames[0]
        actualAnimationFrame = 0
        monsterType = .redmonster
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = resolvedInstance.assetDimensionStep
        }
        gridOffsetY = 0
    }
    
    func squash() {
        monsterState = .falling
        currentImage = deadFrame
    }
    
    func kill(){
        currentImage = deadFrame
        monsterState = .dead
        currentAnimationFrame = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let monsterID:[String: UUID] = ["id": self.id]
            NotificationCenter.default.post(name: .notificationKillRedMonster, object: nil, userInfo: monsterID)
        }
    }
    
    func fall(){
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            moveCounter += 1
            position.y += screenData.assetDimensionStep
            if moveCounter == 8 {
                moveCounter = 0
                if screenData.levelData.checkFalling(xPos: xPos, yPos: yPos) || yPos == screenData.screenDimensionY-1 {
                    kill()
                }
                yPos += 1
            }
        }
    }
    
    func move() {
        guard monsterState != .appearing && monsterState != .dead && monsterState != .still else { return }
        if monsterState == .falling {
            fall()
            return
        } else {
            if monsterType == .digmonster {
                digMove()
            } else {
                monsterMove()
                if currentSpeed == 2 && monsterState != .chasing {
                    chaseMode()
                }
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
                    monsterDirection = .down
                    setOffsets(direction: monsterDirection)
                }
            } else if monsterState == .moving || monsterState == .chasing || monsterState == .still {
                switch monsterDirection {
                case .left:
                    currentImage = leftFrames[actualAnimationFrame]
                case .right:
                    currentImage = rightFrames[actualAnimationFrame]
                case .up:
                    currentImage = upFrames[actualAnimationFrame]
                case .down:
                    currentImage = downFrames[actualAnimationFrame]
                }
                actualAnimationFrame += 1
                if actualAnimationFrame == 3 {
                    actualAnimationFrame = 0
                }
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
        for i in 0..<3 {
            stripeRightFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        for i in 3..<6 {
            stripeDownFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        for i in 6..<9 {
            stripeLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        for i in 9..<12 {
            stripeUpFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        
        deadFrame = getTile(name: "RedMonsters", pos: 12,y:0)!
        blankFrame = getTile(name: "RedMonsters", pos: 12,y:1)!
        
        leftFrames = walkLeftFrames
        rightFrames = walkRightFrames
        upFrames = walkUpFrames
        downFrames = walkDownFrames
    }
    
//    override func nextDirection() -> MonsterDirection {
//        var directionArray:[MonsterDirection] = []
//        if canMoveUp() {directionArray.append(.up)}
//        if canMoveDown() {directionArray.append(.down)}
//        if canMoveLeft() {directionArray.append(.left)}
//        if canMoveRight() {directionArray.append(.right)}
//        if monsterState == .chasing {
//            if let doInstance: MrDo = ServiceLocator.shared.resolve() {
//                /// Dig mode?
//                if !canMoveLeft() && doInstance.yPos == yPos && doInstance.xPos > xPos {
//                    digMode()
//                    return .left
//                }
//                if !canMoveRight() && doInstance.yPos == yPos && doInstance.xPos < xPos {
//                    digMode()
//                    return .right
//                }
//                if !canMoveDown() && doInstance.yPos >= yPos && doInstance.xPos == xPos {
//                    digMode()
//                    return .down
//                }
//                if !canMoveUp() && doInstance.yPos <= yPos && doInstance.xPos == xPos {
//                    digMode()
//                    return .up
//                }
//
//                /// Other direction?
//                if directionArray.contains(.up) && doInstance.yPos < yPos {
//                    directionArray.append(.up)
//                }
//                if directionArray.contains(.down) && doInstance.yPos > yPos {
//                    directionArray.append(.down)
//                }
//                if directionArray.contains(.left) && doInstance.xPos < xPos {
//                    directionArray.append(.left)
//                }
//                if directionArray.contains(.right) && doInstance.xPos > xPos {
//                    directionArray.append(.right)
//                }
//
//                if directionArray.contains(.up) && doInstance.xPos == xPos && doInstance.yPos < yPos {
//                    directionArray.append(.up)
//                    directionArray.append(.up)
//                }
//                if directionArray.contains(.down) && doInstance.xPos == xPos && doInstance.yPos > yPos {
//                    directionArray.append(.down)
//                    directionArray.append(.down)
//                }
//                if directionArray.contains(.left) && doInstance.yPos == yPos  && doInstance.xPos < xPos{
//                    directionArray.append(.left)
//                    directionArray.append(.left)
//                }
//                if directionArray.contains(.right) && doInstance.yPos == yPos  && doInstance.xPos > xPos{
//                    directionArray.append(.right)
//                    directionArray.append(.right)
//                }
//            }
//        }
//        let newDir = directionArray[Int.random(in: 0..<directionArray.count)]
//        setOffsets(direction: newDir)
//        return newDir
//    }
    

    private func chaseMode(){
        leftFrames = chaseLeftFrames
        rightFrames = chaseRightFrames
        upFrames = chaseUpFrames
        downFrames = chaseDownFrames
        monsterState = .chasing
        NotificationCenter.default.post(name: .notificationChaseMode, object: nil, userInfo: nil)
    }
    
    func digMove(){
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            speedCounter += 1
            if speedCounter == currentSpeed {
                speedCounter = 0
                switch monsterDirection {
                case .left:
                    if gridOffsetX == 0 {
                        if canMoveLeft() || checkApple(xPos: xPos-1, yPos: yPos) {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        gridOffsetX = 7
                        xPos -= 1
                        checkGridLeft()
                    } else {
                        gridOffsetX -= 1
                    }
                    position.x -= moveDistance
                    
                case .right:
                    if gridOffsetX == 7 {
                        if canMoveRight() || checkApple(xPos: xPos+1, yPos: yPos)  {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        
                        gridOffsetX = 0
                        xPos += 1
                        checkGridRight()
                    } else {
                        gridOffsetX += 1
                    }
                    position.x += moveDistance
                    
                case .up:
                    if gridOffsetY == 0 {
                        if canMoveUp() || checkApple(xPos: xPos, yPos: yPos-1) || yPos == 0 {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        gridOffsetY = 7
                        yPos -= 1
                        checkGridUp()
                    } else {
                        gridOffsetY -= 1
                    }
                    position.y -= moveDistance
                    
                case .down:
                    if gridOffsetY == 7 {
                        if canMoveDown() || checkApple(xPos: xPos, yPos: yPos+1) || yPos == screenData.screenDimensionY - 1 {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        gridOffsetY = 0
                        yPos += 1
                        checkGridDown()
                    } else {
                        gridOffsetY += 1
                    }
                    position.y += moveDistance
                }
            }
        }
    }
    
    
    private func checkGridUp() {
        guard yPos > 0 else {return}
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos]
            if gridAsset == .ll || gridAsset == .lr || gridAsset == .vt || gridAsset == .tl || gridAsset == .tr || gridAsset == .rt { return }
            
            if gridAsset == .fu || gridAsset == .ch  {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .rt
            }
            if gridAsset == .rl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .tl
            }
            if gridAsset == .rr {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .tr
            }
            if gridAsset == .bl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .ll
            }
            if gridAsset == .br {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lr
            }
            if gridAsset == .hz {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lt
            }
            if gridAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .vt
            }
            if gridAsset == .lb {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .bk
            }
            
            if previousAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .vt
            }
            if previousAsset == .hz {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .lb
            }
            if previousAsset == .tr {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .lr
            }
            if previousAsset == .tl {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .ll
            }
            if previousAsset == .lt {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .bk
            }
            if previousAsset == .rl {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .bl
            }
            if previousAsset == .rr {
                resolvedInstance.levelData.tileArray[yPos+1][xPos] = .br
            }
            
            resolvedInstance.objectWillChange.send()
        }
    }
    private func checkGridDown() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < resolvedInstance.screenDimensionY - 1 else {return}
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos]
            if gridAsset == .ll || gridAsset == .lr || gridAsset == .vt || gridAsset == .bl || gridAsset == .br || gridAsset == .rb { return }
            
            if gridAsset == .fu || gridAsset == .ch  {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .rb
            }
            if gridAsset == .rl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .tl
            }
            if gridAsset == .rr {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .tr
            }
            if gridAsset == .tl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .ll
            }
            if gridAsset == .tr {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lr
            }
            if gridAsset == .hz {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lb
            }
            if gridAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .vt
            }
            
            if previousAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .vt
            }
            if previousAsset == .hz {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .lt
            }
            if previousAsset == .br {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .lr
            }
            if previousAsset == .bl {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .ll
            }
            if previousAsset == .lb {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .bk
            }
            if previousAsset == .rl {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .tl
            }
            if previousAsset == .rr {
                resolvedInstance.levelData.tileArray[yPos-1][xPos] = .tr
            }
            
            resolvedInstance.objectWillChange.send()
        }
    }
    private func checkGridLeft() {
        guard xPos > 0 else {return}
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos][xPos+1]
            if gridAsset == .lt || gridAsset == .lb || gridAsset == .hz || gridAsset == .tl || gridAsset == .bl { return }
            
            if gridAsset == .fu || gridAsset == .ch  {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .rl
            }
            if gridAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .tl
            }
            if gridAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .br
            }
            if gridAsset == .tr {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lt
            }
            if gridAsset == .bl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lb
            }
            if gridAsset == .vt {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .ll
            }
            if gridAsset == .rr {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .hz
            }
            if gridAsset == .br {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lb
            }
            
            if previousAsset == .rl {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .hz
            }
            if previousAsset == .vt {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .lr
            }
            if previousAsset == .tl {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .lt
            }
            if previousAsset == .bl {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .lb
            }
            if previousAsset == .ll {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .bk
            }
            if previousAsset == .lr {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .bk
            }
            if previousAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .tr
            }
            if previousAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .br
            }
            
            resolvedInstance.objectWillChange.send()
        }
    }
    private func checkGridRight() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos < resolvedInstance.screenDimensionX - 1 else {return}
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos][xPos-1]
            if gridAsset == .lt || gridAsset == .lb || gridAsset == .hz || gridAsset == .tr || gridAsset == .br || gridAsset == .rr { return }
            
            if gridAsset == .fu || gridAsset == .ch  {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .rr
            }
            if gridAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .tr
            }
            if gridAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .bl
            }
            if gridAsset == .tl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lt
            }
            if gridAsset == .br {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lb
            }
            if gridAsset == .vt {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .lr
            }
            if gridAsset == .rl {
                resolvedInstance.levelData.tileArray[yPos][xPos] = .hz
            }
            
            if previousAsset == .rr {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .hz
            }
            if previousAsset == .vt {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .ll
            }
            if previousAsset == .tr {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .lt
            }
            if previousAsset == .br {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .lb
            }
            if previousAsset == .lr {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .bk
            }
            if previousAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .tl
            }
            if previousAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos][xPos-1] = .bl
            }
            resolvedInstance.objectWillChange.send()
        }
    }
    
}
