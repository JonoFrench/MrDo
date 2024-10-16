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


final class Ball:SwiftUISprite, Moveable {
    static var speed: Int = GameConstants.ballSpeed
    var thrown = false
    var noCheck = false
    var direction:BallDirection = .downright {
        didSet {
            noCheck = true
        }
    }
    var xAdjust = 0.0
    var yAdjust = 0.0
    var adjustedPosition = CGPoint()
    var tileDirection:TileDirection = .horizontal
    var previousDirection:TileDirection = .horizontal
    ///Can't catch until first change of direction. Otherwise the ball will be caught as soon as thrown.
    var catchable = false
    init() {
#if os(iOS)
        super.init(xPos: 0, yPos: 0, frameSize: CGSize(width: 18, height:  18))
#elseif os(tvOS)
        super.init(xPos: 0, yPos: 0, frameSize: CGSize(width: 36, height:  36))
#endif
    }
    
    func setPosition(xPos: Int, yPos: Int, ballDirection: BallDirection) {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            self.setPosition(xPos: xPos, yPos: yPos)
            direction = ballDirection
            catchable = false
            switch direction {
            case .downleft:
                gridOffsetX = 4
                gridOffsetY = 3
                position.x += resolvedInstance.assetDimensionStep / 2
                position.y -= (resolvedInstance.assetDimensionStep / 8) * 3
            case .upleft:
                gridOffsetX = 4
                gridOffsetY = 3
                //                position.x += resolvedInstance.assetDimensionStep * 1.5
                //                position.y += resolvedInstance.assetDimensionStep * 0.5
            case .downright:
                gridOffsetX = 4
                gridOffsetY = 3
                position.x += resolvedInstance.assetDimensionStep / 2
                position.y -= (resolvedInstance.assetDimensionStep / 8) * 3
            case .upright:
                gridOffsetX = 4
                gridOffsetY = 3
                //                position.x += resolvedInstance.assetDimensionStep * 0.5
                //                position.y += resolvedInstance.assetDimensionStep * 1.5
            }
            adjustedPosition = position
        }
    }
    
    func move() {
        speedCounter += 1
        if speedCounter == GameConstants.ballSpeed {
            switch direction {
            case .downleft:
                print("downleft")
                moveDownLeft()
            case .upleft:
                print("upleft")
                moveUpLeft()
            case .downright:
                print("downright")
                moveDownRight()
            case .upright:
                print("upright")
                moveUpRight()
            }
            previousDirection = tileDirection
            print("Ball x:\(xPos) y:\(yPos) offsetX:\(gridOffsetX) offsetY:\(gridOffsetY)")
            speedCounter = 0
        }
    }
    
    func moveDownLeft() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            position.x -= resolvedInstance.assetDimensionStep
            position.y += resolvedInstance.assetDimensionStep
            gridOffsetX -= 1
            gridOffsetY += 1
//            if noCheck {
//                noCheck = !noCheck
//                return
//            }
//            
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
                if yPos == resolvedInstance.screenDimensionY {
                    yPos = resolvedInstance.screenDimensionY-1
                    gridOffsetY = 7
                    direction = .upright
                    print("moveDownLeft to upright Y edge")
                    return
                }
            }
            
            var checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX-1
            var checkY = gridOffsetY+1
            if checkX < 0 {
                if xPos > 0 {
                    checkX = 7
                    checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos-1]
                    if checkAsset == .fu || checkAsset == .ch {
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
                if yPos < resolvedInstance.screenDimensionY - 1 {
                    checkY = 0
                    checkAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos]
                    if checkAsset == .fu || checkAsset == .ch {
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
            if !resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                
                if checkX == -1 && checkY == 8 {
                    checkAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos-1]
                    checkX = 7
                    checkY = 0
                } else {
                    if checkX == -1 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos-1]
                        checkX = 7
                    }
                    if checkY == 8 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos]
                        checkY = 0
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
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
                    if resolvedInstance.levelData.getWall(type: checkAsset,xOffset: gridOffsetX-1,yOffset: gridOffsetY+1) {
                        direction = .upright
                        print("downleft to upright asset \(checkAsset)")
                    }
                }
            }
        }
    }
    
    func moveDownRight() {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            position.x += resolvedInstance.assetDimensionStep
            position.y += resolvedInstance.assetDimensionStep
            gridOffsetX += 1
            gridOffsetY += 1
//            if noCheck {
//                noCheck = !noCheck
//                return
//            }

            if gridOffsetX >= 8 {
                catchable = true
                xPos += 1
                gridOffsetX = 0
                if xPos == resolvedInstance.screenDimensionX {
                    xPos = resolvedInstance.screenDimensionX-1
                    gridOffsetY = 7
                    direction = .downleft
                    print("moveDownRight to downleft X edge")
                    return
                }            }
            if gridOffsetY >= 8 {
                catchable = true
                yPos += 1
                gridOffsetY = 0
                if yPos == resolvedInstance.screenDimensionY {
                    yPos = resolvedInstance.screenDimensionY-1
                    gridOffsetY = 7
                    direction = .upleft
                    print("moveDownRight to upleft Y edge")
                    return
                }
                
            }
            var checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX+1
            var checkY = gridOffsetY+1
            if checkX > 7 {
                checkX = 0
                checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos+1]
                
                if checkAsset == .fu || checkAsset == .ch {
                    direction = .downleft
                    print("moveDownRight to downleft X full")
                    return
                }
                
            }
            if checkY > 7 {
                if yPos < resolvedInstance.screenDimensionY - 1 {
                    checkY = 0
                    checkAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos]
                    if checkAsset == .fu || checkAsset == .ch {
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
            if !resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                
                if checkX == 8 && checkY == 8 {
                    checkAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos+1]
                    checkX = 0
                    checkY = 0
                } else {
                    if checkX == 8 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos+1]
                        checkX = 0
                    }
                    if checkY == 8 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos]
                        checkY = 0
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
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
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            position.x -= resolvedInstance.assetDimensionStep
            position.y -= resolvedInstance.assetDimensionStep
            gridOffsetX -= 1
            gridOffsetY -= 1
//            if noCheck {
//                noCheck = !noCheck
//                return
//            }

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
            var checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX-1
            var checkY = gridOffsetY-1
            if checkX < 0 {
                if xPos > 0 {
                    checkX = 7
                    checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos-1]
                } else {
                    direction = .upleft
                    return
                }
            }
            if checkY < 0 {
                checkY = 7
                checkAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos]
            }
            checkDirection(checkAsset: checkAsset)
            //1
            if !resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                if checkX == -1 && checkY == -1 {
                    checkAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos-1]
                    checkX = 7
                    checkY = 7
                } else {
                    if checkX == -1 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos-1]
                        checkX = 7
                    }
                    if checkY == -1 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos+1][xPos]
                        checkY = 7
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                    
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
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            position.x += resolvedInstance.assetDimensionStep
            position.y -= resolvedInstance.assetDimensionStep
            gridOffsetX += 1
            gridOffsetY -= 1
//            if noCheck {
//                noCheck = !noCheck
//                return
//            }

            if gridOffsetX >= 8 {
                catchable = true
                xPos += 1
                gridOffsetX = 0
                if xPos == resolvedInstance.screenDimensionX {
                    xPos = resolvedInstance.screenDimensionX - 1
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
            var checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
            var checkX = gridOffsetX+1
            var checkY = gridOffsetY-1
            if checkX > 7 {
                checkX = 0
                checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos+1]
            }
            if checkY < 0 {
                checkY = 7
                checkAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos]
            }
            checkDirection(checkAsset: checkAsset)
            //1 As you where
            if !resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
                return
            } else {
                //2
                
                if checkX == 8 && checkY == -1 {
                    checkAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos+1]
                    checkX = 0
                    checkY = 7
                } else {
                    if checkX == 8 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos+1]
                        checkX = 0
                    }
                    if checkY == -1 {
                        checkAsset = resolvedInstance.levelData.tileArray[yPos-1][xPos]
                        checkY = 7
                    }
                    checkDirection(checkAsset: checkAsset)
                }
                
                if resolvedInstance.levelData.getWall(type: checkAsset,xOffset: checkX,yOffset: checkY) {
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
                    if resolvedInstance.levelData.getWall(type: checkAsset,xOffset: gridOffsetX+1,yOffset: gridOffsetY-1) {
                        direction = .downleft
                        print("upright to downleft asset \(checkAsset)")
                    }
                }
            }
        }
    }
    
    func checkDirection(checkAsset: TileType) {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            tileDirection = resolvedInstance.levelData.getTileDirection(type: checkAsset)
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
    
}
//func moveDownLeft() {
//    if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
//        position.y += resolvedInstance.assetDimensionStep
//        position.x -= resolvedInstance.assetDimensionStep
//        let checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
//        let checkBounce = resolvedInstance.levelData.getWall(type: checkAsset)
//
//        if gridOffsetX == 7 {
//            gridOffsetX = 0
//            print("downleft x asset \(checkAsset)")
//
//            if checkBounce.left || checkAsset == .bk {
//                direction = .downright
//            } else {
//                xPos -= 1
//            }
//        } else {
//            gridOffsetX += 1
//        }
//
//        if gridOffsetY == 7 {
//            gridOffsetY = 0
//            print("downleft y asset \(checkAsset)")
//            if checkBounce.bottom {
//                direction = .upleft
//            } else {
//                yPos += 1
//            }
//        } else {
//            gridOffsetY += 1
//        }
//    }
//}
//func moveDownRight() {
//    if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
//        position.y += resolvedInstance.assetDimensionStep
//        position.x += resolvedInstance.assetDimensionStep
//        let checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
//        let checkBounce = resolvedInstance.levelData.getWall(type: checkAsset)
//
//        if gridOffsetX == 7 {
//            gridOffsetX = 0
//            print("downright x asset \(checkAsset)")
//            if checkBounce.right || checkAsset == .bk {
//                direction = .downleft
//            } else {
//                xPos += 1
//            }
//        } else {
//            gridOffsetX += 1
//        }
//
//        if gridOffsetY == 7 {
//            gridOffsetY = 0
//            print("downright y asset \(checkAsset)")
//            if checkBounce.bottom {
//                direction = .upright
//            } else {
//                yPos += 1
//            }
//        } else {
//            gridOffsetY += 1
//        }
//    }
//}
//func moveUpLeft() {
//    if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
//        position.y -= resolvedInstance.assetDimensionStep
//        position.x -= resolvedInstance.assetDimensionStep
//        let checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
//        let checkBounce = resolvedInstance.levelData.getWall(type: checkAsset)
//
//        if gridOffsetX == 7 {
//            gridOffsetX = 0
//            print("upleft x asset \(checkAsset)")
//            if checkBounce.left || checkAsset == .bk {
//                direction = .upright
//            } else {
//                xPos -= 1
//            }
//        } else {
//            gridOffsetX += 1
//        }
//
//        if gridOffsetY == 7 {
//            gridOffsetY = 0
//            print("upleft y asset \(checkAsset)")
//            if checkBounce.top {
//                direction = .downleft
//            } else {
//                yPos -= 1
//                if yPos == -1 {
//                    yPos = 0
//                    direction = .downleft
//                }
//            }
//
//        } else {
//            gridOffsetY += 1
//        }
//    }
//}
//
//func moveUpRight() {
//    if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
//        position.y -= resolvedInstance.assetDimensionStep
//        position.x += resolvedInstance.assetDimensionStep
//        let checkAsset = resolvedInstance.levelData.tileArray[yPos][xPos]
//        let checkBounce = resolvedInstance.levelData.getWall(type: checkAsset)
//
//        if gridOffsetX == 7 {
//            gridOffsetX = 0
//            print("upright x asset \(checkAsset)")
//            if checkBounce.right || checkAsset == .bk {
//                direction = .upleft
//            } else {
//                xPos += 1
//            }
//        } else {
//            gridOffsetX += 1
//        }
//
//        if gridOffsetY == 7 {
//            gridOffsetY = 0
//            print("upright y asset \(checkAsset)")
//            if checkBounce.top {
//                direction = .downright
//            } else {
//                yPos -= 1
//                if yPos == -1 {
//                    yPos = 0
//                    direction = .downright
//                }
//            }
//        } else {
//            gridOffsetY += 1
//        }
//    }
//}
