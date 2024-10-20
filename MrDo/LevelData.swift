//
//  LevelData.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import Foundation

import SwiftUI
import UIKit

enum TileType:Int {
    case ro,rt,rb,rl,rr,vt,hz,tl,tr,br,bl,lt,ll,lb,lr,fu,ch,bk,tb
}

enum TileDirection {
    case vertical,horizontal,both
}

struct TileWall {
    var left = false
    var right = false
    var top = false
    var bottom = false
    
    init(left: Bool = false, right: Bool = false, top: Bool = false, bottom: Bool = false) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}

class LevelData:ObservableObject {
    let levels = Levels()
    @Published
    var tileArray:[[TileType]] = [[]]
    let tileImage = "Tiles"
    var tileImages:[UIImage] = []
    let tileBackground:[Int] = [0,1,2,3,4,2,5,6,7,8]
    
    init() {
    }
    
    
    let fullWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    
    let blankWalls:[[Int]] = [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]

    let rtWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1]
    ]

    let rbWalls:[[Int]] = [
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,1,0,0,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    let rlWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,1,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]

    let rrWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    
    let tlWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0]
    ]
    let trWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1]
    ]

    let brWalls:[[Int]] = [
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    let blWalls:[[Int]] = [
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,1,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]

    let hzWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    let vtWalls:[[Int]] = [
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1]
    ]
    let ltWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]
    let lbWalls:[[Int]] = [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    let llWalls:[[Int]] = [
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0]
    ]
    let lrWalls:[[Int]] = [
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1]
    ]
    
    let tbWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]

    func getTileDirection(type:TileType) -> TileDirection {
        switch type {
        case .ro:
            return .both
        case .rt:
            return .vertical
        case .rb:
            return .vertical
        case .rl:
            return .horizontal
        case .rr:
            return .horizontal
        case .vt:
            return .vertical
        case .hz:
            return .horizontal
        case .tl:
            return .both
        case .tr:
            return .both
        case .br:
            return .both
        case .bl:
            return .both
        case .lt:
            return .horizontal
        case .ll:
            return .vertical
        case .lb:
            return .horizontal
        case .lr:
            return .vertical
        case .fu:
            return .both
        case .ch:
            return .both
        case .bk:
            return .both
        case .tb:
            return .horizontal
        }
    }
    
    func getWall(type:TileType, xOffset:Int, yOffset:Int) -> Bool {
        switch type {
        case .ro:
            return fullWalls[yOffset][xOffset] == 1 ? true : false
        case .rt:
            return rtWalls[yOffset][xOffset] == 1 ? true : false
        case .rb:
            return rbWalls[yOffset][xOffset] == 1 ? true : false
        case .rl:
            return rlWalls[yOffset][xOffset] == 1 ? true : false
        case .rr:
            return rrWalls[yOffset][xOffset] == 1 ? true : false
        case .vt:
            return vtWalls[yOffset][xOffset] == 1 ? true : false
        case .hz:
            return hzWalls[yOffset][xOffset] == 1 ? true : false
        case .tl:
            return tlWalls[yOffset][xOffset] == 1 ? true : false
        case .tr:
            return trWalls[yOffset][xOffset] == 1 ? true : false
        case .br:
            return brWalls[yOffset][xOffset] == 1 ? true : false
        case .bl:
            return blWalls[yOffset][xOffset] == 1 ? true : false
        case .lt:
            return ltWalls[yOffset][xOffset] == 1 ? true : false
        case .ll:
            return llWalls[yOffset][xOffset] == 1 ? true : false
        case .lb:
            return lbWalls[yOffset][xOffset] == 1 ? true : false
        case .lr:
            return lrWalls[yOffset][xOffset] == 1 ? true : false
        case .fu:
            return fullWalls[yOffset][xOffset] == 1 ? true : false
        case .ch:
            return fullWalls[yOffset][xOffset] == 1 ? true : false
        case .bk:
            return blankWalls[yOffset][xOffset] == 1 ? true : false
        case .tb:
            return tbWalls[yOffset][xOffset] == 1 ? true : false

        }
    }
    
    func setLevelData(level:Int) {
        tileArray = levels.getLevel(level:level)
        tileImages = setTilesFor(level: level)
    }
    
    func setProgress10Data() {
        tileArray = levels.progress10
        tileImages = setTilesFor(level: 10)
    }

    
    func setTilesFor(level:Int) -> [UIImage] {
        var tiles:[UIImage] = []
        for i in 0...17 {
            tiles.append(getTile(level: tileBackground[level - 1], pos: i)!)
        }
        //last one is blank for under the EXTRA
        tiles.append(getTile(level: tileBackground[level - 1], pos: 17)!)

        return tiles
    }
    
    func getTile(level:Int,pos:Int) -> UIImage? {
        guard let image = UIImage(named: tileImage) else { return nil }
        let scale = image.scale
        let rect = CGRect(x: pos * 16, y: level * 16, width: 16, height: 16)
        let scaledRect = CGRect(x: rect.origin.x * scale,
                                y: rect.origin.y * scale,
                                width: rect.size.width * scale,
                                height: rect.size.height * scale)
        //        let rect = CGRect(x: pos * 16, y: level * 16, width: 16 * scale, height: 16 * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return resizeImage(image:UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation),targetSize: CGSize(width: 72, height: 72))
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scale to apply
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Calculate the new size to maintain the aspect ratio
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        // Create a graphics context and draw the image into the context
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        
        // Get the resized image from the context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

struct Levels {
    func getLevel(level:Int) -> [[TileType]] {
        switch level {
        case 1 : return level1
        case 2 : return level2
        case 3 : return level3
        case 4 : return level4
        case 5 : return level5
        case 6 : return level6
        case 7 : return level7
        case 8 : return level8
        case 9 : return level9
        case 10 : return level10
            
        default:
            return level1
        }
    }
    
    let level1:[[TileType]] = [
        [.fu,.fu,.fu,.fu,.rl,.lt,.hz,.hz,.hz,.tr,.fu,.fu],
        [.ch,.ch,.fu,.fu,.fu,.vt,.fu,.fu,.fu,.bl,.tr,.fu],
        [.ch,.ch,.fu,.fu,.fu,.vt,.ch,.ch,.ch,.ch,.bl,.tr],
        [.ch,.ch,.fu,.ch,.ch,.vt,.ch,.ch,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.ch,.ch,.vt,.fu,.fu,.fu,.fu,.fu,.vt],
        [.fu,.fu,.fu,.ch,.ch,.vt,.fu,.fu,.fu,.fu,.fu,.vt],
        [.fu,.fu,.fu,.ch,.ch,.bk,.fu,.fu,.ch,.ch,.fu,.vt],
        [.fu,.fu,.fu,.fu,.fu,.vt,.fu,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.ch,.ch,.fu,.vt,.fu,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.ch,.ch,.fu,.vt,.fu,.fu,.ch,.ch,.fu,.vt],
        [.tl,.hz,.tr,.fu,.fu,.vt,.fu,.fu,.fu,.fu,.tl,.br],
        [.vt,.fu,.vt,.fu,.fu,.vt,.fu,.fu,.fu,.tl,.br,.fu],
        [.bl,.hz,.lb,.hz,.hz,.lb,.hz,.hz,.hz,.br,.fu,.fu]]
    let level2:[[TileType]] = [
        [.fu,.fu,.tl,.hz,.lb,.lb,.lb,.lb,.hz,.tr,.fu,.fu],
        [.fu,.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr,.fu],
        [.tl,.br,.ch,.ch,.ch,.ch,.fu,.fu,.fu,.fu,.bl,.tr],
        [.rb,.fu,.ch,.ch,.ch,.ch,.fu,.fu,.ch,.ch,.fu,.vt],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.fu,.fu,.bk,.fu,.fu,.ch,.ch,.tl,.br],
        [.ch,.ch,.fu,.fu,.fu,.ll,.hz,.hz,.hz,.hz,.br,.fu],
        [.ch,.ch,.fu,.tl,.hz,.br,.fu,.fu,.fu,.fu,.ch,.ch],
        [.fu,.tl,.hz,.br,.ch,.ch,.ch,.ch,.fu,.fu,.ch,.ch],
        [.tl,.br,.fu,.fu,.ch,.ch,.ch,.ch,.fu,.fu,.ch,.ch],
        [.vt,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch],
        [.bl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.rr]]
    let level3:[[TileType]] = [
        [.fu,.fu,.tl,.hz,.lb,.lb,.lb,.lb,.hz,.tr,.fu,.fu],
        [.fu,.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr,.fu],
        [.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr],
        [.rb,.fu,.fu,.ch,.ch,.ch,.ch,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.fu,.fu,.bk,.fu,.fu,.ch,.ch,.tl,.br],
        [.ch,.ch,.fu,.fu,.rl,.lb,.hz,.hz,.hz,.hz,.lr,.fu],
        [.fu,.fu,.fu,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.bl,.tr],
        [.fu,.fu,.fu,.ch,.ch,.fu,.fu,.ch,.ch,.ch,.ch,.vt],
        [.rt,.fu,.fu,.ch,.ch,.fu,.fu,.ch,.ch,.ch,.ch,.vt],
        [.bl,.tr,.fu,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.tl,.br],
        [.fu,.bl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.br,.fu]]
    
    let level4:[[TileType]] = [
        [.fu,.fu,.fu,.fu,.ll,.lb,.lb,.lb,.hz,.tr,.fu,.fu],
        [.ch,.ch,.ch,.ch,.vt,.fu,.fu,.fu,.fu,.vt,.fu,.fu],
        [.ch,.ch,.ch,.ch,.vt,.fu,.fu,.fu,.fu,.vt,.ch,.ch],
        [.fu,.fu,.fu,.tl,.br,.fu,.fu,.fu,.fu,.vt,.ch,.ch],
        [.ch,.ch,.fu,.vt,.fu,.fu,.fu,.ch,.ch,.vt,.ch,.ch],
        [.ch,.ch,.tl,.br,.fu,.fu,.fu,.ch,.ch,.vt,.ch,.ch],
        [.ch,.ch,.vt,.fu,.fu,.bk,.fu,.ch,.ch,.vt,.fu,.fu],
        [.ch,.ch,.ll,.hz,.hz,.br,.fu,.ch,.ch,.vt,.fu,.fu],
        [.tl,.hz,.br,.fu,.fu,.fu,.fu,.fu,.fu,.vt,.fu,.fu],
        [.vt,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.vt,.fu,.fu],
        [.bl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.bk,.hz,.rr],
        [.fu,.ch,.ch,.ch,.ch,.fu,.fu,.fu,.fu,.vt,.fu,.fu],
        [.fu,.ch,.ch,.ch,.ch,.rl,.hz,.hz,.hz,.br,.fu,.fu]]
    
    let level5:[[TileType]] = [
        [.tl,.hz,.hz,.hz,.lb,.lb,.lb,.lb,.hz,.hz,.hz,.rr],
        [.vt,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.vt,.fu,.ch,.ch,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu],
        [.vt,.fu,.ch,.ch,.ch,.ch,.fu,.fu,.ch,.ch,.ch,.ch],
        [.vt,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch,.ch,.ch],
        [.bl,.hz,.hz,.hz,.lt,.lt,.lt,.hz,.hz,.hz,.tr,.fu],
        [.fu,.fu,.fu,.fu,.ll,.bk,.lr,.fu,.fu,.fu,.bl,.tr],
        [.fu,.ch,.ch,.fu,.bl,.lb,.br,.fu,.fu,.ch,.ch,.vt],
        [.fu,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch,.vt],
        [.fu,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.ch,.ch,.vt],
        [.rt,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.ch,.ch,.vt],
        [.bl,.tr,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.tl,.br],
        [.fu,.bl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.br,.fu]]
    
    let level6:[[TileType]] = [
        [.fu,.fu,.tl,.hz,.lb,.lb,.lb,.lb,.hz,.hz,.hz,.rr],
        [.fu,.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.vt,.fu,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.ch,.ch],
        [.vt,.fu,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.ch,.ch],
        [.vt,.fu,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.ch,.ch],
        [.vt,.fu,.ch,.ch,.fu,.bk,.fu,.fu,.fu,.fu,.ch,.ch],
        [.ll,.hz,.hz,.hz,.hz,.lb,.hz,.hz,.hz,.hz,.tr,.fu],
        [.vt,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr],
        [.vt,.ch,.ch,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.vt],
        [.vt,.ch,.ch,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.vt],
        [.bl,.tr,.fu,.fu,.fu,.fu,.ch,.ch,.ch,.ch,.tl,.br],
        [.fu,.bl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.br,.fu]]
    
    let level7:[[TileType]] = [
        [.tl,.hz,.hz,.hz,.lb,.lb,.lb,.lb,.hz,.hz,.hz,.tr],
        [.rb,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.vt],
        [.fu,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.tl,.br],
        [.fu,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.tl,.br,.fu],
        [.fu,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.tl,.br,.fu,.fu],
        [.fu,.ch,.ch,.fu,.fu,.fu,.fu,.tl,.br,.fu,.ch,.ch],
        [.fu,.fu,.fu,.fu,.fu,.bk,.tl,.br,.fu,.fu,.ch,.ch],
        [.fu,.fu,.fu,.fu,.fu,.ll,.br,.fu,.fu,.fu,.ch,.ch],
        [.ch,.ch,.ch,.ch,.fu,.vt,.fu,.ch,.ch,.fu,.ch,.ch],
        [.ch,.ch,.ch,.ch,.fu,.vt,.fu,.ch,.ch,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.vt,.fu,.ch,.ch,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.vt,.fu,.ch,.ch,.fu,.fu,.fu],
        [.fu,.fu,.fu,.rl,.hz,.br,.fu,.fu,.fu,.fu,.fu,.fu]]
    
    let level8:[[TileType]] = [
        [.fu,.fu,.tl,.hz,.lb,.lb,.lb,.lb,.hz,.tr,.fu,.fu],
        [.fu,.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr,.fu],
        [.tl,.br,.ch,.ch,.fu,.ch,.ch,.fu,.ch,.ch,.bl,.tr],
        [.vt,.fu,.ch,.ch,.fu,.ch,.ch,.fu,.ch,.ch,.fu,.vt],
        [.vt,.fu,.ch,.ch,.fu,.ch,.ch,.fu,.ch,.ch,.fu,.vt],
        [.bl,.tr,.ch,.ch,.fu,.ch,.ch,.fu,.ch,.ch,.tl,.br],
        [.fu,.bl,.tr,.fu,.fu,.bk,.fu,.fu,.fu,.tl,.br,.fu],
        [.fu,.fu,.ll,.hz,.hz,.lb,.hz,.hz,.hz,.lr,.fu,.fu],
        [.tl,.hz,.br,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.hz,.tr],
        [.vt,.ch,.ch,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.vt],
        [.vt,.ch,.ch,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.vt],
        [.bl,.tr,.fu,.fu,.fu,.fu,.ch,.ch,.ch,.ch,.tl,.br],
        [.fu,.bl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.br,.fu]]
    
    let level9:[[TileType]] = [
        [.fu,.fu,.tl,.hz,.lb,.lb,.lb,.lb,.hz,.tr,.fu,.fu],
        [.fu,.tl,.br,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr,.fu],
        [.tl,.br,.fu,.fu,.fu,.ch,.ch,.ch,.ch,.fu,.bl,.tr],
        [.vt,.fu,.ch,.ch,.fu,.ch,.ch,.ch,.ch,.fu,.fu,.vt],
        [.vt,.fu,.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.vt],
        [.vt,.fu,.ch,.ch,.fu,.fu,.fu,.ch,.ch,.ch,.ch,.vt],
        [.bl,.tr,.ch,.ch,.fu,.bk,.fu,.ch,.ch,.ch,.ch,.vt],
        [.fu,.bl,.hz,.hz,.hz,.lb,.hz,.hz,.hz,.hz,.hz,.lr],
        [.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.vt],
        [.ch,.ch,.fu,.fu,.fu,.fu,.ch,.ch,.ch,.ch,.fu,.vt],
        [.ch,.ch,.fu,.fu,.fu,.fu,.ch,.ch,.ch,.ch,.tl,.br],
        [.ch,.ch,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.tl,.br,.fu],
        [.rl,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.hz,.br,.fu,.fu]]
    
    let level10:[[TileType]] = [
        [.fu,.fu,.tl,.hz,.lb,.lb,.lb,.lb,.hz,.tr,.fu,.fu],
        [.fu,.tl,.lr,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr,.fu],
        [.tl,.br,.bl,.tr,.fu,.fu,.fu,.fu,.fu,.fu,.bl,.tr],
        [.vt,.fu,.fu,.bl,.tr,.fu,.ch,.ch,.ch,.ch,.fu,.vt],
        [.vt,.fu,.fu,.fu,.bl,.tr,.ch,.ch,.ch,.ch,.fu,.vt],
        [.vt,.ch,.ch,.ch,.ch,.vt,.fu,.fu,.fu,.fu,.fu,.vt],
        [.vt,.ch,.ch,.ch,.ch,.bk,.fu,.fu,.fu,.ch,.ch,.vt],
        [.vt,.fu,.fu,.fu,.fu,.vt,.fu,.fu,.fu,.ch,.ch,.vt],
        [.vt,.ch,.ch,.ch,.ch,.bl,.hz,.tr,.fu,.ch,.ch,.vt],
        [.vt,.ch,.ch,.ch,.ch,.fu,.fu,.bl,.tr,.ch,.ch,.vt],
        [.bl,.tr,.fu,.fu,.ch,.ch,.ch,.ch,.bl,.tr,.tl,.br],
        [.fu,.bl,.tr,.fu,.ch,.ch,.ch,.ch,.fu,.ll,.br,.fu],
        [.fu,.fu,.bl,.hz,.hz,.hz,.hz,.hz,.hz,.br,.fu,.fu]]
    
    let levelX:[[TileType]] = [
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu]]
    
    let progress10:[[TileType]] = [
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.bk,.bk,.bk,.bk,.bk,.bk,.fu,.fu,.fu],
        [.fu,.fu,.fu,.bk,.bk,.bk,.bk,.bk,.bk,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu],
        [.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu]]
}
