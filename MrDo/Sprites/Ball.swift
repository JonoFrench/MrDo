//
//  Ball.swift
//  MrDo
//
//  Created by Jonathan French on 20.09.24.
//

import Foundation
import SwiftUI

enum BallDirection {
    case downleft,upleft,downright,upright
}

enum ExplodeDirection {
    case downleft,upleft,downright,upright,up,down,left,right
}

struct explodeBall {
    let id:UUID = UUID()
    let direction:ExplodeDirection
    var position:CGPoint
}

final class Ball:SwiftUISprite, Moveable {
    static var speed: Int = GameConstants.Speed.ballSpeed
    @Published
    var exploding = false
    @Published
    var imploding = false
    @Published
    var explodeArray:[explodeBall] = []
    var direction:BallDirection = .downright
    ///Can't catch until first change of direction. Otherwise the ball will be caught as soon as thrown.
    var catchable = false
    var thrown = false
    private var explodeCount = 0
    private var implodePosition = CGPoint()
    private var explodePosition = CGPoint()
    private var tileDirection:TileDirection = .horizontal
    private var previousDirection:TileDirection = .horizontal
    private var ballSwitch = false

    init() {
        super.init(xPos: 0, yPos: 0, frameSize: GameConstants.Size.ballSize)
    }
    
    func setPosition(xPos: Int, yPos: Int, ballDirection: BallDirection) {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            currentFrame = ImageResource(name: "Ball", bundle: .main)
            self.setPosition(xPos: xPos, yPos: yPos)
            direction = ballDirection
            catchable = false
            switch direction {
            case .downleft:
                gridOffsetX = 4
                gridOffsetY = 3
                position.x += screenData.assetDimensionStep / 2
                position.y -= (screenData.assetDimensionStep / 8) * 3
            case .upleft:
                gridOffsetX = 4
                gridOffsetY = 3
                //                position.x += screenData.assetDimensionStep * 1.5
                //                position.y += screenData.assetDimensionStep * 0.5
            case .downright:
                gridOffsetX = 4
                gridOffsetY = 3
                position.x += screenData.assetDimensionStep / 2
                position.y -= (screenData.assetDimensionStep / 8) * 3
            case .upright:
                gridOffsetX = 4
                gridOffsetY = 3
                //                position.x += screenData.assetDimensionStep * 0.5
                //                position.y += screenData.assetDimensionStep * 1.5
            }
        }
    }
    
    func reset() {
        explodeArray.removeAll()
        exploding = false
        imploding = false
        explodeCount = 0
    }
    
    func move() {
        speedCounter += 1
        if speedCounter == GameConstants.Speed.ballSpeed {
//            currentFrame = ballSwitch ? ImageResource(name: "Ball1", bundle: .main) : ImageResource(name: "Ball2", bundle: .main)
//            ballSwitch = !ballSwitch
            switch direction {
            case .downleft:
                print("downleft")
                currentFrame = ImageResource(name: "Ball2", bundle: .main)
                moveDownLeft()
            case .upleft:
                print("upleft")
                currentFrame = ImageResource(name: "Ball2", bundle: .main)
                moveUpLeft()
            case .downright:
                print("downright")
                currentFrame = ImageResource(name: "Ball1", bundle: .main)
                moveDownRight()
            case .upright:
                print("upright")
                currentFrame = ImageResource(name: "Ball1", bundle: .main)
                moveUpRight()
            }
            previousDirection = tileDirection
            print("Ball x:\(xPos) y:\(yPos) offsetX:\(gridOffsetX) offsetY:\(gridOffsetY)")
            speedCounter = 0
        }
    }
    
    func moveDownLeft() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            position.x -= screenData.assetDimensionStep
            position.y += screenData.assetDimensionStep
            gridOffsetX -= 1
            gridOffsetY += 1
            if gridOffsetX <= -1 {
                catchable = true
                xPos -= 1
                gridOffsetX = 7
                if xPos == -1 {
                    xPos = 0
                    gridOffsetY = 0
                    direction = .downright
                    print("moveDownLeft to downright X edge")
                    return
                }            }
            if gridOffsetY >= 8 {
                catchable = true
                yPos += 1
                gridOffsetY = 0
                if yPos == screenData.screenDimensionY {
                    yPos = screenData.screenDimensionY-1
                    gridOffsetY = 7
                    direction = .upright
                    print("moveDownLeft to upright Y edge")
                    return
                }
            }
            
            var checkAsset = screenData.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX-1
            var checkY = gridOffsetY+1
            if checkX < 0 {
                if xPos > 0 {
                    checkX = 7
                    checkAsset = screenData.levelData.tileArray[yPos][xPos-1]
                    if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos-1, yPos: yPos) {
                        direction = .downright
                        print("moveDownLeft to downright X full")
                        return
                    }

                } else {
                    checkX = 0
                    direction = .downright
                    print("moveDownLeft to downright X else")
                    return
                }
            }
            if checkY > 7 {
                if yPos < screenData.screenDimensionY - 1 {
                    checkY = 0
                    checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
                    if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos, yPos: yPos+1) {
                        direction = .upright
                        print("moveDownLeft to upright Y full")
                        return
                    }

                } else {
                    direction = .upright
                    print("moveDownLeft to upright Y else")
                    return

                }
            }
            checkDirection(checkAsset: checkAsset)
            //1
            if !screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                
                if checkX == -1 && checkY == 8 {
                    checkAsset = screenData.levelData.tileArray[yPos-1][xPos-1]
                    checkX = 7
                    checkY = 0
                } else {
                    if checkX == -1 {
                        checkAsset = screenData.levelData.tileArray[yPos][xPos-1]
                        checkX = 7
                    }
                    if checkY == 8 {
                        checkAsset = screenData.levelData.tileArray[yPos-1][xPos]
                        checkY = 0
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                    if checkAsset == .rb && checkY > 5 {
                        print("downleft to upright asset \(checkAsset)")
                        direction = .upright
                        return
                    }
                    
                    if (checkAsset == .rl || checkAsset == .bl) && checkX < 3 {
                        print("downleft to upright asset \(checkAsset)")
                        direction = .upright
                        return
                    }
                    
                    if tileDirection == .horizontal {
                        direction = .upleft
                        print("downleft to upleft asset \(checkAsset)")
                    } else if tileDirection == .vertical {
                        direction = .downright
                        print("downleft to downright asset \(checkAsset)")
                    }
                } else {
                    if screenData.levelData.getWall(type: checkAsset,xOffset: gridOffsetX-1,yOffset: gridOffsetY+1) {
                        direction = .upright
                        print("downleft to upright asset \(checkAsset)")
                    }
                }
            }
        }
    }
    
    func moveDownRight() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            position.x += screenData.assetDimensionStep
            position.y += screenData.assetDimensionStep
            gridOffsetX += 1
            gridOffsetY += 1

            if gridOffsetX >= 8 {
                catchable = true
                xPos += 1
                gridOffsetX = 0
                if xPos == screenData.screenDimensionX {
                    xPos = screenData.screenDimensionX-1
                    gridOffsetY = 7
                    direction = .downleft
                    print("moveDownRight to downleft X edge")
                    return
                }            }
            if gridOffsetY >= 8 {
                catchable = true
                yPos += 1
                gridOffsetY = 0
                if yPos == screenData.screenDimensionY {
                    yPos = screenData.screenDimensionY-1
                    gridOffsetY = 7
                    direction = .upleft
                    print("moveDownRight to upleft Y edge")
                    return
                }
                
            }
            var checkAsset = screenData.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX+1
            var checkY = gridOffsetY+1
            if checkX > 7 {
                checkX = 0
                checkAsset = screenData.levelData.tileArray[yPos][xPos+1]
                
                if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos+1, yPos: yPos) {
                    direction = .downleft
                    print("moveDownRight to downleft X full")
                    return
                }
                
            }
            if checkY > 7 {
                if yPos < screenData.screenDimensionY - 1 {
                    checkY = 0
                    checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
                    if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos, yPos: yPos+1) {
                        direction = .upright
                        print("moveDownRight to upright Y full")
                        return
                    }
                } else {
                    direction = .upleft
                    print("moveDownRight to upleft Y else")
                    return

                }
            }
            checkDirection(checkAsset: checkAsset)
            //1 As you where
            if !screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                
                if checkX == 8 && checkY == 8 {
                    checkAsset = screenData.levelData.tileArray[yPos+1][xPos+1]
                    checkX = 0
                    checkY = 0
                } else {
                    if checkX == 8 {
                        checkAsset = screenData.levelData.tileArray[yPos][xPos+1]
                        checkX = 0
                    }
                    if checkY == 8 {
                        checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
                        checkY = 0
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                    if checkAsset == .rb && checkY > 5 {
                        print("downright to upleft asset \(checkAsset)")
                        direction = .upleft
                        return
                    }
                    
                    if checkAsset == .rr && checkX > 5 {
                        print("downleft to upright asset \(checkAsset)")
                        direction = .upleft
                        return
                    }
                    
                    if tileDirection == .horizontal {
                        direction = .upright
                        print("downright to upright asset \(checkAsset)")
                    } else if tileDirection == .vertical {
                        direction = .downleft
                        print("downright to downleft asset \(checkAsset)")
                    }
                } else {
                    direction = .upleft
                    print("downright to upleft asset \(checkAsset)")
                }
            }
        }
    }
    func moveUpLeft() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            position.x -= screenData.assetDimensionStep
            position.y -= screenData.assetDimensionStep
            gridOffsetX -= 1
            gridOffsetY -= 1

            if gridOffsetX <= -1 {
                catchable = true
                xPos -= 1
                gridOffsetX = 7
                if xPos == -1 {
                    xPos = 0
                    gridOffsetY = 0
                    direction = .upright
                    print("moveUpLeft to upright X edge")
                    return
                }
            }
            if gridOffsetY <= -1 {
                catchable = true
                yPos -= 1
                gridOffsetY = 7
                if yPos == -1 {
                    yPos = 0
                    gridOffsetY = 0
                    direction = .downleft
                    print("moveUpLeft to downleft Y edge")
                    return
                }
            }
            var checkAsset = screenData.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX-1
            var checkY = gridOffsetY-1
            if checkX < 0 {
                if xPos > 0 {
                    checkX = 7
                    checkAsset = screenData.levelData.tileArray[yPos][xPos-1]
                    if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos-1, yPos: yPos) {
                        direction = .upright
                        print("moveUpLeft to upright X full")
                        return
                    }

                } else {
                    direction = .upleft
                    return
                }
            }
            if checkY < 0 {
                if yPos > 0 {
                    checkY = 7
                    checkAsset = screenData.levelData.tileArray[yPos-1][xPos]
                    if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos, yPos: yPos-1) {
                        direction = .downleft
                        print("moveUpLeft to downright Y full")
                        return
                    }

                } else {
                    direction = .downleft
                    return
                }
            }
            checkDirection(checkAsset: checkAsset)
            //1
            if !screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                if checkX == -1 && checkY == -1 {
                    checkAsset = screenData.levelData.tileArray[yPos+1][xPos-1]
                    checkX = 7
                    checkY = 7
                } else {
                    if checkX == -1 {
                        checkAsset = screenData.levelData.tileArray[yPos][xPos-1]
                        checkX = 7
                    }
                    if checkY == -1 {
                        checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
                        checkY = 7
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                    
                    if checkAsset == .rt && checkY < 3 {
                        print("upleft to downright asset \(checkAsset)")
                        direction = .downright
                        return
                    }
                    if checkAsset == .rl && checkX < 3 {
                        print("upleft to downright asset \(checkAsset)")
                        direction = .downright
                        return
                    }
                    
                    if tileDirection == .horizontal {
                        direction = .downleft
                        print("upleft to downleft asset \(checkAsset)")
                    } else if tileDirection == .vertical {
                        direction = .upright
                        print("upleft to upright asset \(checkAsset)")
                    }
                } else {
                    print("upleft to downright asset \(checkAsset)")
                    direction = .downright
                }
            }
        }
    }
    
    func moveUpRight() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            position.x += screenData.assetDimensionStep
            position.y -= screenData.assetDimensionStep
            gridOffsetX += 1
            gridOffsetY -= 1

            if gridOffsetX >= 8 {
                catchable = true
                xPos += 1
                gridOffsetX = 0
                if xPos == screenData.screenDimensionX {
                    xPos = screenData.screenDimensionX - 1
                    gridOffsetY = 7
                    direction = .upleft
                    print("moveUpRight to upleft X edge")
                    return
                }
            }
            if gridOffsetY == -1 {
                catchable = true
                yPos -= 1
                gridOffsetY = 7
                if yPos == -1 {
                    yPos = 0
                    gridOffsetY = 0
                    direction = .downleft
                    print("moveUpRight to downleft Y edge")
                    return
                }
            }
            var checkAsset = screenData.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX+1
            var checkY = gridOffsetY-1
            if checkX > 7 {
                checkX = 0
                checkAsset = screenData.levelData.tileArray[yPos][xPos+1]
                
                if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos+1, yPos: yPos) {
                    direction = .upleft
                    print("moveUpRight to upleft X full")
                    return
                }

            }
            if checkY < 0 {
                if yPos > 0 {
                    checkY = 7
                    checkAsset = screenData.levelData.tileArray[yPos-1][xPos]
                    if checkAsset == .fu || checkAsset == .ch || checkApple(xPos: xPos, yPos: yPos - 1) {
                        direction = .downright
                        print("moveUpRight to downright Y full")
                        return
                    }

                } else {
                    direction = .downright
                    return
                }
            }
            checkDirection(checkAsset: checkAsset)
            //1 As you where
            if !screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                
                if checkX == 8 && checkY == -1 {
                    checkAsset = screenData.levelData.tileArray[yPos-1][xPos+1]
                    checkX = 0
                    checkY = 7
                } else {
                    if checkX == 8 {
                        checkAsset = screenData.levelData.tileArray[yPos][xPos+1]
                        checkX = 0
                    }
                    if checkY == -1 {
                        checkAsset = screenData.levelData.tileArray[yPos-1][xPos]
                        checkY = 7
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if screenData.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                    if checkAsset == .rt && checkY < 3 {
                        print("upright to downleft asset \(checkAsset)")
                        direction = .downleft
                        return
                    }
                    
                    if checkAsset == .rr && checkX > 5 {
                        print("downleft to upright asset \(checkAsset)")
                        direction = .downleft
                        return
                    }
                    
                    if tileDirection == .horizontal {
                        direction = .downright
                        print("upright to downright asset \(checkAsset)")
                    } else if tileDirection == .vertical {
                        direction = .upleft
                        print("upright to upleft asset \(checkAsset)")
                    }
                } else {
                    if screenData.levelData.getWall(type: checkAsset,xOffset: gridOffsetX+1,yOffset: gridOffsetY-1) {
                        direction = .downleft
                        print("upright to downleft asset \(checkAsset)")
                    }
                }
            }
        }
    }
    
    private func checkApple(xPos:Int, yPos:Int) -> Bool {
        if let appleArray: AppleArray = ServiceLocator.shared.resolve() {
            for apple in appleArray.apples {
                if apple.xPos == xPos && apple.yPos == yPos {
                    return true
                }
            }
        }
        return false
    }
    
    private func checkDirection(checkAsset: TileType) {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            tileDirection = screenData.levelData.getTileDirection(type: checkAsset)
            if tileDirection == .both {
                if previousDirection == .vertical {
                    tileDirection = .horizontal
                    print("Horizontal")
                } else if previousDirection == .horizontal {
                    tileDirection = .vertical
                    print("Vertical")
                }
                previousDirection = tileDirection
            }
        }
    }
    
    func setImplode(position:CGPoint) {
        imploding = true
        implodePosition = position
        currentFrame = ImageResource(name: "Ball", bundle: .main)
        let distance = 8.0 * 15
        explodeArray.append(explodeBall(direction: .left, position: CGPoint(x: implodePosition.x - distance, y: implodePosition.y)))
        explodeArray.append(explodeBall(direction: .up, position: CGPoint(x: implodePosition.x, y: implodePosition.y + distance)))
        explodeArray.append(explodeBall(direction: .down, position: CGPoint(x: implodePosition.x, y: implodePosition.y - distance)))
        explodeArray.append(explodeBall(direction: .right, position: CGPoint(x: implodePosition.x + distance, y: implodePosition.y)))
        explodeArray.append(explodeBall(direction: .upleft, position: CGPoint(x: implodePosition.x - distance, y: implodePosition.y + distance)))
        explodeArray.append(explodeBall(direction: .upright, position: CGPoint(x: implodePosition.x + distance, y: implodePosition.y + distance)))
        explodeArray.append(explodeBall(direction: .downleft, position: CGPoint(x: implodePosition.x - distance, y: implodePosition.y - distance)))
        explodeArray.append(explodeBall(direction: .downright, position: CGPoint(x: implodePosition.x + distance, y: implodePosition.y - distance)))
    }

    
    func setExplode(position:CGPoint) {
        exploding = true
        thrown = false
        explodePosition = position
        currentFrame = ImageResource(name: "Ball", bundle: .main)
        explodeArray.append(explodeBall(direction: .left, position: explodePosition))
        explodeArray.append(explodeBall(direction: .up, position: explodePosition))
        explodeArray.append(explodeBall(direction: .down, position: explodePosition))
        explodeArray.append(explodeBall(direction: .right, position: explodePosition))
        explodeArray.append(explodeBall(direction: .upleft, position: explodePosition))
        explodeArray.append(explodeBall(direction: .upright, position: explodePosition))
        explodeArray.append(explodeBall(direction: .downleft, position: explodePosition))
        explodeArray.append(explodeBall(direction: .downright, position: explodePosition))
    }
    
    func explode() {
        explodeCount += 1
        if explodeCount == 15 {
            setExplode(position: explodePosition)
        }
        if explodeCount == 30 {
            explodeArray.removeAll()
            explodeCount = 0
            exploding = false
            return
        }
        let distance = 8.0
        for index in 0..<explodeArray.count {
            var ball = explodeArray[index]
            switch ball.direction {
            case .downleft:
                ball.position.x -= distance
                ball.position.y -= distance
            case .upleft:
                ball.position.x -= distance
                ball.position.y += distance
            case .downright:
                ball.position.x += distance
                ball.position.y -= distance
            case .upright:
                ball.position.x += distance
                ball.position.y += distance
            case .up:
                ball.position.y += distance
            case .down:
                ball.position.y -= distance
            case .left:
                ball.position.x -= distance
            case .right:
                ball.position.x += distance
            }
            explodeArray[index] = ball
        }
    }
    
    func implode() {
        explodeCount += 1
        if explodeCount == 15 {
            setImplode(position: implodePosition)
        }
        if explodeCount == 30 {
            explodeArray.removeAll()
            explodeCount = 0
            imploding = false
            catchable = false
            if let doInstance: MrDo = ServiceLocator.shared.resolve() {
                doInstance.hasBall = true
                doInstance.animate()
            }
            return
        }
        let distance = 8.0
        for index in 0..<explodeArray.count {
            var ball = explodeArray[index]
            switch ball.direction {
            case .downleft:
                ball.position.x += distance
                ball.position.y += distance
            case .upleft:
                ball.position.x += distance
                ball.position.y -= distance
            case .downright:
                ball.position.x -= distance
                ball.position.y += distance
            case .upright:
                ball.position.x -= distance
                ball.position.y -= distance
            case .up:
                ball.position.y -= distance
            case .down:
                ball.position.y += distance
            case .left:
                ball.position.x += distance
            case .right:
                ball.position.x -= distance
            }
            explodeArray[index] = ball
        }
        
    }
}
