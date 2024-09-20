//
//  MrDo.swift
//  MrDo
//
//  Created by Jonathan French on 19.09.24.
//

import Foundation
import SwiftUI

enum DoState {
    case still,walking,dead
}
enum DoDirection {
    case left,right,up,down,stop
}

final class MrDo:SwiftUISprite,Moveable,Animatable, ObservableObject {
    static var animateFrames: Int = 0
    static var speed: Int = GameConstants.doSpeed
    var walkRightFrames: [UIImage] = []
    var walkLeftFrames: [UIImage] = []
    var walkUpFrames: [UIImage] = []
    var walkDownFrames: [UIImage] = []
    var direction:DoDirection = .stop
    var willStop = false
    
    override init(xPos: Int, yPos: Int, frameSize: CGSize) {
        super.init(xPos: xPos, yPos: yPos, frameSize: frameSize)
        
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

        currentImage = walkRightFrames[0]
        gridOffsetX = 2
        gridOffsetY = 3
    }

    func setup(xPos: Int, yPos: Int) {
        setPosition(xPos: xPos, yPos: yPos)
        direction = .stop
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = resolvedInstance.assetDimensionStep * Double(GameConstants.doSpeed)
        }
    }
    
    
    func move() {
        speedCounter += 1
        if speedCounter == GameConstants.doSpeed + 1 {
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
            speedCounter = 0
        }
    }
    
    func moveNothing(){
    }
    
    func animate() {
        currentAnimationFrame += 1
        if currentAnimationFrame == 3 {
            currentAnimationFrame = 0
        }

        switch direction {
        case .left:
            currentImage = walkLeftFrames[currentAnimationFrame]
        case .right:
            currentImage = walkRightFrames[currentAnimationFrame]
        case .up:
            currentImage = walkUpFrames[currentAnimationFrame]
        case .down:
            currentImage = walkDownFrames[currentAnimationFrame]
        case .stop:
            print("nothing")
        }
        
    }
    
    func checkGridUp() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos]
            if gridAsset == .ch {
                // add cherry to score
            }
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

    func checkGridDown() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos]
            if gridAsset == .ch {
                // add cherry to score
            }
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
    func checkGridLeft() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos][xPos+1]
            if gridAsset == .ch {
                // add cherry to score
            }
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

            if previousAsset == .rt {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .tr
            }
            if previousAsset == .rb {
                resolvedInstance.levelData.tileArray[yPos][xPos+1] = .br
            }

            
            resolvedInstance.objectWillChange.send()
        }
    }
    func checkGridRight() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let gridAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            let previousAsset = resolvedInstance.levelData.tileArray[yPos][xPos-1]
            if gridAsset == .ch {
                // add cherry to score
            }
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

    
    func moveRight() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            if (xPos == resolvedInstance.screenDimensionX - 1 && gridOffsetX == 2) {return}
            print("Do Right offset \(gridOffsetX) xPos \(xPos)")
            position.x += moveDistance
            gridOffsetX += 1
            if gridOffsetX >= Int(GameConstants.tileSteps) / GameConstants.doSpeed {
                gridOffsetX = 0
                if xPos < resolvedInstance.screenDimensionX {
                    xPos += 1
                    checkGridRight()
                }
            }
            animate()
        }
    }

    func moveLeft() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            if (xPos == 0 && gridOffsetX == 2) {return}
            print("Do Left offset \(gridOffsetX) xPos \(xPos)")
            position.x -= moveDistance
            gridOffsetX -= 1
            if gridOffsetX < 0 {
                gridOffsetX = Int(GameConstants.tileSteps) / GameConstants.doSpeed - 1
                if xPos > 0 {
                    xPos -= 1
                    checkGridLeft()
                }
            }
            animate()
        }
    }
    
    func moveUp() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            print("Do up offset \(gridOffsetY) yPos \(yPos)")
            if (yPos == 0 && gridOffsetY == 3) {return}
            position.y -= moveDistance
            gridOffsetY -= 1
            if gridOffsetY < 0 {
                gridOffsetY = Int(GameConstants.tileSteps) / GameConstants.doSpeed - 1
                if yPos > 0 {
                    yPos -= 1
                    checkGridUp()
                }
            }
            animate()
        }
    }
    func moveDown() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            print("Do down offset \(gridOffsetY) yPos \(yPos)")
            if (yPos == resolvedInstance.screenDimensionY - 1 && gridOffsetY == 3) {return}
            position.y += moveDistance
            gridOffsetY += 1
            if gridOffsetY >= Int(GameConstants.tileSteps) / GameConstants.doSpeed {
                gridOffsetY = 0
                if yPos < resolvedInstance.screenDimensionY {
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
                currentImage = walkLeftFrames[currentAnimationFrame]
                direction = .stop
                willStop = false
            }
        case .right:
            if gridOffsetX == 2 {
                currentAnimationFrame = 0
                currentImage = walkRightFrames[currentAnimationFrame]
                direction = .stop
                willStop = false
            }
        case .up:
            if gridOffsetY == 3 {
                currentAnimationFrame = 0
                currentImage = walkUpFrames[currentAnimationFrame]
                direction = .stop
                willStop = false
            }
        case .down:
            if gridOffsetY == 3 {
                currentAnimationFrame = 0
                currentImage = walkDownFrames[currentAnimationFrame]
                direction = .stop
                willStop = false
            }
        case .stop:
            print("stop")
        }
    }

    
}
