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
    private let tileImage = "Tiles"
    var tileImages:[UIImage] = []
    private let tileBackground:[Int] = [0,1,2,3,4,2,5,6,7,8,3,4,2,5,6,7,9,1,10,0,5,6,7,9,1,10,3,4,2,11,12]
    private var fallSet:Set = [TileType.rb,.lb,.br,.bl,.ch,.fu,.hz,.rl,.rr]

    init() {
    }
    
    func setLevelData(screenLevel:Int,gameLevel:Int) {
        tileArray = levels.getLevel(level:screenLevel)
        tileImages = setTilesFor(level: gameLevel)
    }
    
    func setExtraLevelData() {
        tileImages = setTilesFor(level: 31)
    }

    func resetExtraLevelData(gameLevel:Int) {
        tileImages = setTilesFor(level: gameLevel)
    }

    func setProgress10Data() {
        tileArray = levels.progress10
        tileImages = setTilesFor(level: 10)
    }

    func setIntroScreen() {
        tileArray = levels.introScreen
        tileImages = setTilesFor(level: 1)
    }
    
    func checkFalling(xPos:Int,yPos:Int) -> Bool {
        if fallSet.contains(tileArray[yPos][xPos]) {
            return true
        }
        return false
    }
    
    private let fullWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    
    private let blankWalls:[[Int]] = [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]

    private let rtWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1]
    ]

    private let rbWalls:[[Int]] = [
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,1,0,0,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    private let rlWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,1,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]

    private let rrWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    
    private let tlWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0]
    ]
    private let trWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1]
    ]

    private let brWalls:[[Int]] = [
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,1,1,1],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    private let blWalls:[[Int]] = [
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,1,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]

    private let hzWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    private let vtWalls:[[Int]] = [
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1],
        [1,1,0,0,0,0,1,1]
    ]
    private let ltWalls:[[Int]] = [
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]
    private let lbWalls:[[Int]] = [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1]
    ]
    private let llWalls:[[Int]] = [
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0]
    ]
    private let lrWalls:[[Int]] = [
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,1,1]
    ]
    
    private let tbWalls:[[Int]] = [
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
    
    func setTilesFor(level:Int) -> [UIImage] {
        var tiles:[UIImage] = []
        for i in 0...17 {
            tiles.append(getTile(level: tileBackground[level - 1], pos: i)!)
        }
        //last one is blank for under the EXTRA
        tiles.append(getTile(level: tileBackground[level - 1], pos: 17)!)
        return tiles
    }

    func getTile(name:String,pos:Int) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        let rect = CGRect(x: pos * 16, y: 0, width: 16, height: 16)
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    func getTile(level:Int,pos:Int) -> UIImage? {
        guard let image = UIImage(named: tileImage) else { return nil }
        let scale = image.scale
        let rect = CGRect(x: pos * 16, y: level * 16, width: 16, height: 16)
        let scaledRect = CGRect(x: rect.origin.x * scale,
                                y: rect.origin.y * scale,
                                width: rect.size.width * scale,
                                height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return resizeImage(image:UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation),targetSize: CGSize(width: 72, height: 72))
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
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
    
    private let level1:[[TileType]] = [
        [.fu,.fu,.fu,.fu,.bl,.bk,.lb,.lb,.hz,.tr,.fu,.fu],
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
    private let level2:[[TileType]] = [
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
    private let level3:[[TileType]] = [
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
    
    private let level4:[[TileType]] = [
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
    
    private let level5:[[TileType]] = [
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
    
    private let level6:[[TileType]] = [
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
    
    private let level7:[[TileType]] = [
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
    
    private let level8:[[TileType]] = [
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
    
    private let level9:[[TileType]] = [
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
    
    private let level10:[[TileType]] = [
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
    
    private let levelX:[[TileType]] = [
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
    
    let introScreen:[[TileType]] = [
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.bk],
        [.bk,.fu,.rl,.hz,.hz,.hz,.hz,.hz,.hz,.rr,.fu,.bk],
        [.bk,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.bk],
        [.bk,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.bk],
        [.bk,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.rt,.fu,.bk],
        [.bk,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.rb,.fu,.bk],
        [.bk,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.fu,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk],
        [.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk,.bk]]

}
