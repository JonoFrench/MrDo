//
//  MrDo.swift
//  MrDo
//
//  Created by Jonathan French on 19.09.24.
//

import Foundation
import SwiftUI

enum DoState {
    case still,walking,falling,dead
}
enum DoDirection {
    case left,right,up,down,stop
}

final class MrDo:SwiftUISprite,Moveable,Animatable {
    static var speed: Int = GameConstants.Speed.doSpeed
    @Published
    var hasBall = false
    @Published
    var isPushing = false

    private var walkRightFrames: [UIImage] = []
    private var walkLeftFrames: [UIImage] = []
    private var walkUpFrames: [UIImage] = []
    private var walkDownFrames: [UIImage] = []
    private var walkRightBallFrames: [UIImage] = []
    private var walkLeftBallFrames: [UIImage] = []
    private var walkUpBallFrames: [UIImage] = []
    private var walkDownBallFrames: [UIImage] = []
    
    private var pushRightFrames: [UIImage] = []
    private var pushLeftFrames: [UIImage] = []
    private var pushUpFrames: [UIImage] = []
    private var pushDownFrames: [UIImage] = []
    private var pushRightBallFrames: [UIImage] = []
    private var pushLeftBallFrames: [UIImage] = []
    private var pushUpBallFrames: [UIImage] = []
    private var pushDownBallFrames: [UIImage] = []
    private var dieFrames: [UIImage] = []
    private var wasCherry = false
    private var cherryCount = 0
    private var pushedApple: Apple?

    var direction:DoDirection = .stop
    private var previousDirection:DoDirection = .stop
    var facing:DoDirection = .right {
        didSet {
            if oldValue != facing {
                animate()
            }
        }
    }
    var willStop = false
    var doState:DoState = .still
    
    init () {
        super.init(xPos: 0, yPos: 0, frameSize: GameConstants.Size.doSize)
        setImages()
        currentImage = walkRightBallFrames[0]
        gridOffsetX = 2
        gridOffsetY = 3
    }
    
    func setup(xPos: Int, yPos: Int) {
        setPosition(xPos: xPos, yPos: yPos)
        direction = .stop
        facing = .right
        hasBall = true
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = screenData.assetDimensionStep * Double(GameConstants.Speed.doSpeed)
        }
    }
    
    func reset() {
        currentAnimationFrame = 0
        currentImage = walkRightBallFrames[0]
        willStop = false
        xPos = 5
        yPos = 12
        gridOffsetX = 2
        gridOffsetY = 3
        direction = .stop
        facing = .right
        hasBall = true
        doState = .still
        setPosition(xPos: 5, yPos: 12)
    }
    
    func setImages() {
        for i in 0..<3 {
            walkRightFrames.append(getTile(name: "DoWalking", pos: i)!)
        }
        for i in 3..<6 {
            walkDownFrames.append(getTile(name: "DoWalking", pos: i)!)
        }
        for i in 6..<9 {
            walkLeftFrames.append(getTile(name: "DoWalking", pos: i)!)
        }
        for i in 9..<12 {
            walkUpFrames.append(getTile(name: "DoWalking", pos: i)!)
        }
        for i in 0..<3 {
            walkRightBallFrames.append(getTile(name: "DoWalkingBall", pos: i)!)
        }
        for i in 3..<6 {
            walkDownBallFrames.append(getTile(name: "DoWalkingBall", pos: i)!)
        }
        for i in 6..<9 {
            walkLeftBallFrames.append(getTile(name: "DoWalkingBall", pos: i)!)
        }
        for i in 9..<12 {
            walkUpBallFrames.append(getTile(name: "DoWalkingBall", pos: i)!)
        }
        
        for i in 0..<3 {
            pushRightFrames.append(getTile(name: "DoPushing", pos: i)!)
        }
        for i in 3..<6 {
            pushDownFrames.append(getTile(name: "DoPushing", pos: i)!)
        }
        for i in 6..<9 {
            pushLeftFrames.append(getTile(name: "DoPushing", pos: i)!)
        }
        for i in 9..<12 {
            pushUpFrames.append(getTile(name: "DoPushing", pos: i)!)
        }
        
        for i in 0..<3 {
            pushRightBallFrames.append(getTile(name: "DoPushingBall", pos: i)!)
        }
        for i in 3..<6 {
            pushDownBallFrames.append(getTile(name: "DoPushingBall", pos: i)!)
        }
        for i in 6..<9 {
            pushLeftBallFrames.append(getTile(name: "DoPushingBall", pos: i)!)
        }
        for i in 9..<12 {
            pushUpBallFrames.append(getTile(name: "DoPushingBall", pos: i)!)
        }
        for i in 0..<5 {
            dieFrames.append(getTile(name: "DoDie", pos: i)!)
        }
    }
    
    func move() {
        if doState == .falling {
            fall()
            return
        }
        speedCounter += 1
        if speedCounter == GameConstants.Speed.doSpeed + 1 {
            speedCounter = 0
            if doState == .dead {
                die()
                return
            }
            if willStop {
                moveStop()
            }
            switch direction {
            case .left:
                moveLeft()
            case .right:
                moveRight()
            case .up:
                moveUp()
            case .down:
                moveDown()
            case .stop:
                moveNothing()
            }
        }
    }
    
    func moveNothing(){
    }
    
    func fall(){
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            moveCounter += 1
            position.y += screenData.assetDimensionStep
            print("Do falling moveCounter \(moveCounter) pos \(position.y)")
            if moveCounter == 8 {
                moveCounter = 0
                if screenData.levelData.checkFalling(xPos: xPos, yPos: yPos) || yPos == screenData.screenDimensionY {
                    doState = .dead
                    currentAnimationFrame = 0
                    screenData.soundFX.loseLifeSound()
                    die()
                }
                yPos += 1
            }
        }
    }
    
    func killed() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            doState = .dead
            currentAnimationFrame = 0
            screenData.soundFX.loseLifeSound()
            die()
        }
    }
    
    func die() {
        guard currentAnimationFrame < dieFrames.count else { return }
        currentImage = dieFrames[currentAnimationFrame]
        currentAnimationFrame += 1
        if currentAnimationFrame == 5 {
            NotificationCenter.default.post(name: .notificationLoseLife, object: nil, userInfo: nil)
        }
    }
    
    func animate() {
        guard doState != .dead else {return}
        currentAnimationFrame += 1
        if currentAnimationFrame == 3 {
            currentAnimationFrame = 0
        }
        switch facing {
        case .left:
            if hasBall {
                if isPushing {
                    currentImage = pushLeftBallFrames[currentAnimationFrame]
                } else {
                    currentImage = walkLeftBallFrames[currentAnimationFrame]
                }
            } else {
                if isPushing {
                    currentImage = pushLeftFrames[currentAnimationFrame]
                } else {
                    currentImage = walkLeftFrames[currentAnimationFrame]
                }
            }
        case .right:
            if hasBall {
                if isPushing {
                    currentImage = pushRightBallFrames[currentAnimationFrame]
                } else {
                    currentImage = walkRightBallFrames[currentAnimationFrame]
                }
            }
            else {
                if isPushing {
                    currentImage = pushRightFrames[currentAnimationFrame]
                } else {
                    currentImage = walkRightFrames[currentAnimationFrame]
                }
            }
        case .up:
            if hasBall {
                currentImage = walkUpBallFrames[currentAnimationFrame]
            }
            else {
                currentImage = walkUpFrames[currentAnimationFrame]
            }
        case .down:
            if hasBall {
                currentImage = walkDownBallFrames[currentAnimationFrame]
            }
            else {
                currentImage = walkDownFrames[currentAnimationFrame]
            }
        case .stop:
            print("nothing")
        }
    }
    
    func addCherry() {
        if wasCherry {
            cherryCount += 1
        } else {
            cherryCount = 1
        }
        let value:[String: Int] = ["count":cherryCount]
        NotificationCenter.default.post(name: .notificationCherryScore, object: nil, userInfo: value)
        wasCherry = true
    }
    
    private func checkGridUp(){
        let prevTiles = [TileType.ro,.vt,.rb,.bl,.br,.vt,.lb,.ll,.lr,.br,.bl,.bk,.ll,.lb,.lr,.fu,.ch,.bk]
        let swapTiles = [TileType.ro,.rt,.vt,.tl,.tr,.vt,.lt,.tl,.tr,.lr,.ll,.lt,.ll,.bk,.lr,.rt,.rt,.bk]
        let upSet:Set = [TileType.ll,.lr,.vt,.tl,.tr,.rt]
        guard yPos >= 0 else {return}
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos+1][xPos]
            if upSet.contains(gridAsset) { return }
            if gridAsset == .ch { addCherry()
            } else { wasCherry = false }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos+1][xPos] = prevTiles[p!]
                screenData.objectWillChange.send()
        }
    }
    
    private func checkGridLeft(){
        let swapTiles = [TileType.ro,.tl,.br,.tl,.hz,.ll,.lb,.ll,.lt,.lb,.lb,.lt,.ll,.bk,.lr,.rl,.rl,.bk]
        let prevTiles = [TileType.ro,.tr,.br,.hz,.tr,.lr,.hz,.lt,.lr,.lr,.lb,.bk,.bk,.bk,.bk,.fu,.ch,.bk]
        let leftSet:Set = [TileType.lt,.lb,.hz,.tl,.bl,.lr]
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos >= 0 else {return}
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos][xPos+1]
            if leftSet.contains(gridAsset) { return }
            if gridAsset == .ch { addCherry()
            } else { wasCherry = false }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos][xPos+1] = prevTiles[p!]
                screenData.objectWillChange.send()
        }
    }
    
    private func checkGridRight(){
        let swapTiles = [TileType.ro,.tr,.bl,.hz,.hz,.lr,.lb,.lt,.lt,.lb,.lb,.lt,.ll,.bk,.lr,.rr,.rr,.bk]
        let prevTiles = [TileType.ro,.tl,.bl,.hz,.hz,.ll,.lt,.lt,.lt,.lb,.lb,.bk,.bk,.bk,.bk,.fu,.ch,.bk]
        let rightSet:Set = [TileType.lt,.lb,.hz,.tr,.br,.rr]
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard xPos < screenData.screenDimensionX else {return}
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos][xPos-1]
            if rightSet.contains(gridAsset) { return }
            if gridAsset == .ch { addCherry()
            } else { wasCherry = false }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos][xPos-1] = prevTiles[p!]
                screenData.objectWillChange.send()
        }
    }
    
//    private func checkGridUp() {
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos+1][xPos]
//            if gridAsset == .ch {
//                // add cherry to score
//                addCherry()
//            } else {
//                wasCherry = false
//            }
//            if gridAsset == .ll || gridAsset == .lr || gridAsset == .vt || gridAsset == .tl || gridAsset == .tr || gridAsset == .rt { return }
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
        let fullTiles = [TileType.ro,.rt,.rb,.rl,.rr,.vt,.hz,.tl,.tr,.br,.bl,.lt,.ll,.lb,.lr,.fu,.ch,.bk]
        let swapTiles = [TileType.ro,.vt,.vt,.tl,.tr,.vt,.lb,.ll,.lr,.lr,.ll,.lt,.ll,.lb,.lr,.rb,.rb,.bk]
        let prevTiles = [TileType.ro,.vt,.vt,.tl,.tr,.vt,.lt,.ll,.lr,.lr,.ll,.bk,.ll,.lb,.lr,.fu,.ch,.bk]
        let downSet:Set = [TileType.ll,.lr,.vt,.bl,.br,.rb]
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            guard yPos < screenData.screenDimensionY else {return}
            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
            let previousAsset = screenData.levelData.tileArray[yPos-1][xPos]
            if downSet.contains(gridAsset) { return }
            if gridAsset == .ch { addCherry()
            } else { wasCherry = false }
            let i = fullTiles.firstIndex(of: gridAsset)
            let p = fullTiles.firstIndex(of: previousAsset)
                screenData.levelData.tileArray[yPos][xPos] = swapTiles[i!]
                screenData.levelData.tileArray[yPos-1][xPos] = prevTiles[p!]
                screenData.objectWillChange.send()
        }
    }
    
    
//    private func checkGridDown() {
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos-1][xPos]
//            if gridAsset == .ch {
//                // add cherry to score
//                addCherry()
//            } else {
//                wasCherry = false
//            }
//            if gridAsset == .ll || gridAsset == .lr || gridAsset == .vt || gridAsset == .bl || gridAsset == .br || gridAsset == .rb { return }
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
//    private func checkGridLeft() {
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos][xPos+1]
//            if gridAsset == .ch {
//                // add cherry to score
//                addCherry()
//            } else {
//                wasCherry = false
//            }
//            if gridAsset == .lt || gridAsset == .lb || gridAsset == .hz || gridAsset == .tl || gridAsset == .bl { return }
//            
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
//    private func checkGridRight() {
//        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
//            let gridAsset = screenData.levelData.tileArray[yPos][xPos]
//            let previousAsset = screenData.levelData.tileArray[yPos][xPos-1]
//            if gridAsset == .ch {
//                // add cherry to score
//                addCherry()
//            } else {
//                wasCherry = false
//            }
//            if gridAsset == .lt || gridAsset == .lb || gridAsset == .hz || gridAsset == .tr || gridAsset == .br || gridAsset == .rr { return }
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
//            
//            screenData.objectWillChange.send()
//            
//        }
//    }
    
    func moveRight() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            facing = .right
            if (xPos == screenData.screenDimensionX - 1 && gridOffsetX == 2) {return}
            if appleRight() && gridOffsetX == 2 && !canPushRight() { return }
            print("Do Right offset \(gridOffsetX) xPos \(xPos)")
            position.x += moveDistance
            if isPushing {
                pushedApple?.position.x += moveDistance
                print("pushing apple")
            }
            
            gridOffsetX += 1
            if gridOffsetX >= Int(GameConstants.Speed.tileSteps) / GameConstants.Speed.doSpeed {
                gridOffsetX = 0
                if xPos < screenData.screenDimensionX {
                    xPos += 1
                    checkGridRight()
                    if isPushing {
                        pushedApple?.position.x += moveDistance
                        pushedApple?.isPushed = true
                        pushedApple?.xPos += 1
                        isPushing = false
                    }
                }
            }
            animate()
        }
    }
    
    func moveLeft() {
        facing = .left
        if (xPos == 0 && gridOffsetX == 2) {return}
        if appleLeft() && gridOffsetX == 2 && !canPushLeft() { return }
        print("Do Left offset \(gridOffsetX) xPos \(xPos)")
        position.x -= moveDistance
        if isPushing {
            pushedApple?.position.x -= moveDistance
            print("pushing apple")
        }
        gridOffsetX -= 1
        if gridOffsetX < 0 {
            gridOffsetX = Int(GameConstants.Speed.tileSteps) / GameConstants.Speed.doSpeed - 1
            if xPos > 0 {
                xPos -= 1
                checkGridLeft()
                if isPushing {
                    //                        pushedApple?.position.x -= moveDistance
                    pushedApple?.isPushed = true
                    pushedApple?.xPos -= 1
                    isPushing = false
                }
            }
        }
        animate()
        
    }
    
    func moveUp() {
        facing = .up
        print("Do up offset \(gridOffsetY) yPos \(yPos)")
        if (yPos == 0 && gridOffsetY == 3) {return}
        if appleAbove() { return }
        position.y -= moveDistance
        gridOffsetY -= 1
        if gridOffsetY < 0 {
            gridOffsetY = Int(GameConstants.Speed.tileSteps) / GameConstants.Speed.doSpeed - 1
            if yPos > 0 {
                yPos -= 1
                checkGridUp()
            }
        }
        animate()
        
    }
    func moveDown() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            facing = .down
            print("Do down offset \(gridOffsetY) yPos \(yPos)")
            if (yPos == screenData.screenDimensionY - 1 && gridOffsetY == 3) {return}
            if appleBelow() { return }
            position.y += moveDistance
            gridOffsetY += 1
            if gridOffsetY >= Int(GameConstants.Speed.tileSteps) / GameConstants.Speed.doSpeed {
                gridOffsetY = 0
                if yPos < screenData.screenDimensionY {
                    yPos += 1
                    checkGridDown()
                }
            }
            animate()
        }
    }
    func moveStop() {
        switch direction {
        case .left:
            if gridOffsetX == 2 {
                currentAnimationFrame = 0
                if hasBall {
                    if isPushing {
                        currentImage = pushLeftBallFrames[currentAnimationFrame]
                    } else {
                        currentImage = walkLeftBallFrames[currentAnimationFrame]
                        
                    }
                } else {
                    if isPushing {
                        currentImage = pushLeftFrames[currentAnimationFrame]
                    } else {
                        currentImage = walkLeftFrames[currentAnimationFrame]
                    }
                }
                direction = .stop
                willStop = false
            }
        case .right:
            if gridOffsetX == 2 {
                currentAnimationFrame = 0
                if hasBall {
                    if isPushing {
                        currentImage = pushRightBallFrames[currentAnimationFrame]
                    } else {
                        currentImage = walkRightBallFrames[currentAnimationFrame]
                    }
                } else {
                    if isPushing {
                        currentImage = pushRightFrames[currentAnimationFrame]
                    } else {
                        currentImage = walkRightFrames[currentAnimationFrame]
                    }
                }
                direction = .stop
                willStop = false
            }
        case .up:
            if gridOffsetY == 3 {
                currentAnimationFrame = 0
                if hasBall {
                    currentImage = walkUpBallFrames[currentAnimationFrame]
                } else {
                    currentImage = walkUpFrames[currentAnimationFrame]
                }
                direction = .stop
                willStop = false
            }
        case .down:
            if gridOffsetY == 3 {
                currentAnimationFrame = 0
                if hasBall {
                    currentImage = walkDownBallFrames[currentAnimationFrame]
                } else {
                    currentImage = walkDownFrames[currentAnimationFrame]
                }
                direction = .stop
                willStop = false
            }
        case .stop:
            print("stop")
            willStop = false
        }
    }
    
    private func appleAbove() -> Bool {
        ///Is there an apple above?
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.yPos+1 == yPos && apple.xPos == xPos {
                    print("Apple Above")
                    pushedApple = apple
                    return true
                }
            }
        }
        return false
    }
    
    private func appleBelow() -> Bool {
        ///Is there an apple below?
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.yPos == yPos && apple.xPos == xPos {
                    pushedApple = apple
                    return true
                }
            }
        }
        return false
    }
    
    private func appleLeft() -> Bool {
        ///Is there an apple to the left?
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.xPos+1 == xPos && apple.yPos == yPos {
                    pushedApple = apple
                    return true
                }
            }
        }
        return false
    }
    
    private func appleRight() -> Bool {
        ///Is there an apple to the right?
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.xPos-1 == xPos && apple.yPos == yPos {
                    pushedApple = apple
                    return true
                }
            }
        }
        return false
    }
    
    private func canPushLeft() -> Bool {
        guard isPushing == false else { return false }
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            ///Can we push the apple?
            if let pushedApple {
                if pushedApple.xPos == 0 {return false}
                let screenAsset = screenData.levelData.tileArray[pushedApple.yPos][pushedApple.xPos-1]
                if screenAsset != .ch && screenAsset != .fu {
                    pushedApple.position.x -= moveDistance
                    isPushing = true
                    return true
                }
            }
        }
        return false
    }
    
    private func canPushRight() -> Bool {
        guard isPushing == false else { return false }
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            ///Can we push the apple?
            if let pushedApple {
                if pushedApple.xPos == screenData.screenDimensionX - 1 {return false}
                let screenAsset = screenData.levelData.tileArray[pushedApple.yPos][pushedApple.xPos+1]
                if screenAsset != .ch && screenAsset != .fu {
                    pushedApple.position.x += moveDistance
                    isPushing = true
                    return true
                }
            }
        }
        return false
    }
}
