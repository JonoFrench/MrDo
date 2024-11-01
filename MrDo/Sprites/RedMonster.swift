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
    private var increaseSpeedCounter = 0
    
    init(xPos: Int, yPos: Int) {
        super.init(xPos: xPos, yPos: yPos, frameSize: GameConstants.Size.redMonsterSize)
        setImages()
        currentImage = walkRightFrames[0]
        actualAnimationFrame = 0
        monsterType = .redmonster
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = screenData.assetDimensionStep
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
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.monsterKillDelay))
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
        for i in 0..<3 { walkRightFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!) }
        for i in 3..<6 { walkDownFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!) }
        for i in 6..<9 { walkLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!) }
        for i in 9..<12 { walkUpFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!) }
        for i in 0..<3 { chaseRightFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!) }
        for i in 3..<6 { chaseDownFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!) }
        for i in 6..<9 { chaseLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!) }
        for i in 9..<12 { chaseUpFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!) }
        for i in 0..<3 { stripeRightFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!) }
        for i in 3..<6 { stripeDownFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!) }
        for i in 6..<9 { stripeLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)}
        for i in 9..<12 { stripeUpFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!) }
        deadFrame = getTile(name: "RedMonsters", pos: 12,y:0)!
        blankFrame = getTile(name: "RedMonsters", pos: 12,y:1)!
        leftFrames = walkLeftFrames
        rightFrames = walkRightFrames
        upFrames = walkUpFrames
        downFrames = walkDownFrames
    }

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
                        if canMoveLeft() || checkApple(xPos: xPos-1, yPos: yPos) || xPos == 0 {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        gridOffsetX = 7
                        xPos -= 1
                        checkGridLeft()
                    } else { gridOffsetX -= 1 }
                    position.x -= moveDistance
                    
                case .right:
                    if gridOffsetX == 7 {
                        if canMoveRight() || checkApple(xPos: xPos+1, yPos: yPos) || xPos == screenData.screenDimensionX-1  {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        gridOffsetX = 0
                        xPos += 1
                        checkGridRight()
                    } else { gridOffsetX += 1 }
                    position.x += moveDistance
                    
                case .up:
                    if gridOffsetY == 0 {
                        if canMoveUp() || checkApple(xPos: xPos, yPos: yPos-1) {
                            monsterType = .redmonster
                            chaseMode()
                            monsterDirection = nextDirection()
                            return
                        }
                        gridOffsetY = 7
                        yPos -= 1
                        checkGridUp()
                    } else { gridOffsetY -= 1}
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
                    } else { gridOffsetY += 1 }
                    position.y += moveDistance
                }
            }
        }
    }
    
    private func checkGridUp(){
        let prevTiles = [TileType.ro,.vt,.rb,.bl,.br,.vt,.lb,.ll,.lr,.br,.bl,.bk,.ll,.lb,.lr,.fu,.ch,.bk]
        let swapTiles = [TileType.ro,.rt,.vt,.tl,.tr,.vt,.lt,.tl,.tr,.lr,.ll,.lt,.ll,.bk,.lr,.rt,.rt,.bk]
        let upSet:Set = [TileType.ll,.lr,.vt,.tl,.tr]
        guard yPos > 0 else {return}
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos+1][xPos]
            if upSet.contains(gridAsset) { return }
            if gridAsset == .ch { eatCherry() }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.5))
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos+1][xPos] = prevTiles[p!]
                screenData.objectWillChange.send()
            }
        }
    }
    
//    private func checkGridUp() {
//        guard yPos > 0 else {return}
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos+1][xPos]
//            if gridAsset == .ll || gridAsset == .lr || gridAsset == .vt || gridAsset == .tl || gridAsset == .tr || gridAsset == .rt { return }
//            
//            if gridAsset == .ch {
//                eatCherry()
//            }
//
//            if gridAsset == .fu || gridAsset == .ch  {
//                screenData.levelData.tileArray[yPos][xPos] = .rt
//            }
//            if gridAsset == .rl {
//                screenData.levelData.tileArray[yPos][xPos] = .tl
//            }
//            if gridAsset == .rr {
//                screenData.levelData.tileArray[yPos][xPos] = .tr
//            }
//            if gridAsset == .bl {
//                screenData.levelData.tileArray[yPos][xPos] = .ll
//            }
//            if gridAsset == .br {
//                screenData.levelData.tileArray[yPos][xPos] = .lr
//            }
//            if gridAsset == .hz {
//                screenData.levelData.tileArray[yPos][xPos] = .lt
//            }
//            if gridAsset == .rb {
//                screenData.levelData.tileArray[yPos][xPos] = .vt
//            }
//            if gridAsset == .lb {
//                screenData.levelData.tileArray[yPos][xPos] = .bk
//            }
//            
//            if previousAsset == .rt {
//                screenData.levelData.tileArray[yPos+1][xPos] = .vt
//            }
//            if previousAsset == .hz {
//                screenData.levelData.tileArray[yPos+1][xPos] = .lb
//            }
//            if previousAsset == .tr {
//                screenData.levelData.tileArray[yPos+1][xPos] = .lr
//            }
//            if previousAsset == .tl {
//                screenData.levelData.tileArray[yPos+1][xPos] = .ll
//            }
//            if previousAsset == .lt {
//                screenData.levelData.tileArray[yPos+1][xPos] = .bk
//            }
//            if previousAsset == .rl {
//                screenData.levelData.tileArray[yPos+1][xPos] = .bl
//            }
//            if previousAsset == .rr {
//                screenData.levelData.tileArray[yPos+1][xPos] = .br
//            }
//            
//            screenData.objectWillChange.send()
//        }
//    }

    private func checkGridDown(){
        let swapTiles = [TileType.ro,.vt,.vt,.tl,.tr,.vt,.lb,.ll,.lr,.lr,.ll,.lt,.ll,.bk,.lr,.rb,.rb,.bk]
        let prevTiles = [TileType.ro,.vt,.vt,.tl,.tr,.vt,.lt,.ll,.lr,.lr,.ll,.bk,.ll,.bk,.lr,.fu,.ch,.bk]
        let downSet:Set = [TileType.ll,.lr,.vt,.bl,.br]
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < screenData.screenDimensionY - 1 else {return}
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos-1][xPos]
            if downSet.contains(gridAsset) { return }
            if gridAsset == .ch { eatCherry() }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.5))
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos-1][xPos] = prevTiles[p!]
                screenData.objectWillChange.send()
            }
        }
    }

//    private func checkGridDown() {
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            guard yPos < screenData.screenDimensionY - 1 else {return}
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos-1][xPos]
//            if gridAsset == .ll || gridAsset == .lr || gridAsset == .vt || gridAsset == .bl || gridAsset == .br || gridAsset == .rb { return }
//            if gridAsset == .ch {
//                eatCherry()
//            }
//
//            if gridAsset == .fu || gridAsset == .ch  {
//                screenData.levelData.tileArray[yPos][xPos] = .rb
//            }
//            if gridAsset == .rl {
//                screenData.levelData.tileArray[yPos][xPos] = .tl
//            }
//            if gridAsset == .rr {
//                screenData.levelData.tileArray[yPos][xPos] = .tr
//            }
//            if gridAsset == .tl {
//                screenData.levelData.tileArray[yPos][xPos] = .ll
//            }
//            if gridAsset == .tr {
//                screenData.levelData.tileArray[yPos][xPos] = .lr
//            }
//            if gridAsset == .hz {
//                screenData.levelData.tileArray[yPos][xPos] = .lb
//            }
//            if gridAsset == .rt {
//                screenData.levelData.tileArray[yPos][xPos] = .vt
//            }
//            
//            if previousAsset == .rb {
//                screenData.levelData.tileArray[yPos-1][xPos] = .vt
//            }
//            if previousAsset == .hz {
//                screenData.levelData.tileArray[yPos-1][xPos] = .lt
//            }
//            if previousAsset == .br {
//                screenData.levelData.tileArray[yPos-1][xPos] = .lr
//            }
//            if previousAsset == .bl {
//                screenData.levelData.tileArray[yPos-1][xPos] = .ll
//            }
//            if previousAsset == .lb {
//                screenData.levelData.tileArray[yPos-1][xPos] = .bk
//            }
//            if previousAsset == .rl {
//                screenData.levelData.tileArray[yPos-1][xPos] = .tl
//            }
//            if previousAsset == .rr {
//                screenData.levelData.tileArray[yPos-1][xPos] = .tr
//            }
//            
//            screenData.objectWillChange.send()
//        }
//    }
    
    private func checkGridLeft(){
        let swapTiles = [TileType.ro,.tl,.br,.tl,.hz,.ll,.lb,.ll,.lt,.lb,.lb,.lt,.ll,.bk,.lr,.rl,.rl,.bk]
        let prevTiles = [TileType.ro,.tr,.br,.hz,.tr,.lr,.lt,.lt,.lr,.lr,.lb,.bk,.bk,.bk,.bk,.fu,.ch,.bk]
        let leftSet:Set = [TileType.lt,.lb,.hz,.tl,.bl]
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < screenData.screenDimensionY - 1 else {return}
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos][xPos+1]
            if leftSet.contains(gridAsset) { return }
            if gridAsset == .ch { eatCherry() }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.5))
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos][xPos+1] = prevTiles[p!]
                screenData.objectWillChange.send()
            }
        }
    }
    
//    private func checkGridLeft() {
//        guard xPos > 0 else {return}
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos][xPos+1]
//            if gridAsset == .lt || gridAsset == .lb || gridAsset == .hz || gridAsset == .tl || gridAsset == .bl { return }
//            
//            if gridAsset == .ch {
//                eatCherry()
//            }
//            if gridAsset == .fu || gridAsset == .ch  {
//                screenData.levelData.tileArray[yPos][xPos] = .rl
//            }
//            if gridAsset == .rt {
//                screenData.levelData.tileArray[yPos][xPos] = .tl
//            }
//            if gridAsset == .rb {
//                screenData.levelData.tileArray[yPos][xPos] = .br
//            }
//            if gridAsset == .tr {
//                screenData.levelData.tileArray[yPos][xPos] = .lt
//            }
//            if gridAsset == .bl {
//                screenData.levelData.tileArray[yPos][xPos] = .lb
//            }
//            if gridAsset == .vt {
//                screenData.levelData.tileArray[yPos][xPos] = .ll
//            }
//            if gridAsset == .rr {
//                screenData.levelData.tileArray[yPos][xPos] = .hz
//            }
//            if gridAsset == .br {
//                screenData.levelData.tileArray[yPos][xPos] = .lb
//            }
//            
//            if previousAsset == .rl {
//                screenData.levelData.tileArray[yPos][xPos+1] = .hz
//            }
//            if previousAsset == .vt {
//                screenData.levelData.tileArray[yPos][xPos+1] = .lr
//            }
//            if previousAsset == .tl {
//                screenData.levelData.tileArray[yPos][xPos+1] = .lt
//            }
//            if previousAsset == .bl {
//                screenData.levelData.tileArray[yPos][xPos+1] = .lb
//            }
//            if previousAsset == .ll {
//                screenData.levelData.tileArray[yPos][xPos+1] = .bk
//            }
//            if previousAsset == .lr {
//                screenData.levelData.tileArray[yPos][xPos+1] = .bk
//            }
//            if previousAsset == .rt {
//                screenData.levelData.tileArray[yPos][xPos+1] = .tr
//            }
//            if previousAsset == .rb {
//                screenData.levelData.tileArray[yPos][xPos+1] = .br
//            }
//            
//            screenData.objectWillChange.send()
//        }
//    }
    
    private func checkGridRight(){
        let swapTiles = [TileType.ro,.tr,.bl,.hz,.hz,.lr,.lb,.lt,.lt,.lb,.lb,.lt,.ll,.bk,.lr,.rr,.rr,.bk]
        let prevTiles = [TileType.ro,.tl,.bl,.hz,.hz,.ll,.lt,.lt,.lt,.lb,.lb,.bk,.bk,.bk,.bk,.fu,.ch,.bk]
        let rightSet:Set = [TileType.lt,.lb,.hz,.tr,.br,.rr]
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < screenData.screenDimensionY - 1 else {return}
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos][xPos-1]
            if rightSet.contains(gridAsset) { return }
            if gridAsset == .ch { eatCherry() }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.5))
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos][xPos-1] = prevTiles[p!]
                screenData.objectWillChange.send()
            }
        }
    }
    
//    private func checkGridRight() {
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            guard xPos < screenData.screenDimensionX - 1 else {return}
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos][xPos-1]
//            if gridAsset == .lt || gridAsset == .lb || gridAsset == .hz || gridAsset == .tr || gridAsset == .br || gridAsset == .rr { return }
//            
//            if gridAsset == .ch {
//                eatCherry()
//            }
//
//            if gridAsset == .fu || gridAsset == .ch  {
//                screenData.levelData.tileArray[yPos][xPos] = .rr
//            }
//            if gridAsset == .rt {
//                screenData.levelData.tileArray[yPos][xPos] = .tr
//            }
//            if gridAsset == .rb {
//                screenData.levelData.tileArray[yPos][xPos] = .bl
//            }
//            if gridAsset == .tl {
//                screenData.levelData.tileArray[yPos][xPos] = .lt
//            }
//            if gridAsset == .br {
//                screenData.levelData.tileArray[yPos][xPos] = .lb
//            }
//            if gridAsset == .vt {
//                screenData.levelData.tileArray[yPos][xPos] = .lr
//            }
//            if gridAsset == .rl {
//                screenData.levelData.tileArray[yPos][xPos] = .hz
//            }
//            
//            if previousAsset == .rr {
//                screenData.levelData.tileArray[yPos][xPos-1] = .hz
//            }
//            if previousAsset == .vt {
//                screenData.levelData.tileArray[yPos][xPos-1] = .ll
//            }
//            if previousAsset == .tr {
//                screenData.levelData.tileArray[yPos][xPos-1] = .lt
//            }
//            if previousAsset == .br {
//                screenData.levelData.tileArray[yPos][xPos-1] = .lb
//            }
//            if previousAsset == .lr {
//                screenData.levelData.tileArray[yPos][xPos-1] = .bk
//            }
//            if previousAsset == .rt {
//                screenData.levelData.tileArray[yPos][xPos-1] = .tl
//            }
//            if previousAsset == .rb {
//                screenData.levelData.tileArray[yPos][xPos-1] = .bl
//            }
//            screenData.objectWillChange.send()
//        }
//    }
    
    func eatCherry() {
        let value:[String: Int] = ["count":-1]
        NotificationCenter.default.post(name: .notificationCherryScore, object: nil, userInfo: value)
    }

    
}
