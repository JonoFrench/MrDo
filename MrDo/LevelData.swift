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
    case ro,rt,rb,rl,rr,vt,hz,tl,tr,br,bl,lt,ll,lb,lr,fu,ch,bk
}

class LevelData:ObservableObject {
    let levels = Levels()
    @Published
    var tileArray:[[TileType]] = [[]]
    let tileImage = "Tiles"
    var tileImages:[UIImage] = []

//    func tileImage(tileType:TileType) -> UIImage {
//        let tile = tileType.rawValue
//        return getTile(pos: tile)!
//    }
    
    init() {
    }
    
    func setLevelData(level:Int) {
        tileArray = levels.getLevel(level:level)
        tileImages = setTilesFor(level: level)
    }
    
    func setTilesFor(level:Int) -> [UIImage] {
        var tiles:[UIImage] = []
        for i in 0...17 {
            tiles.append(getTile(level: level - 1, pos: i)!)
        }
        return tiles
    }
    
    func getTile(level:Int,pos:Int) -> UIImage? {
        guard let image = UIImage(named: tileImage) else { return nil }
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
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
        return nil
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
        [.fu,.fu,.tl,.hz,.hz,.hz,.hz,.hz,.hz,.tr,.fu,.fu],
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
        [.fu,.fu,.tl,.hz,.hz,.hz,.hz,.hz,.hz,.tr,.fu,.fu],
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
}
