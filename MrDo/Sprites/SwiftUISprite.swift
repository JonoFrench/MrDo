//
//  SwiftUISprite.swift
//  DonkeyKong
//
//  Created by Jonathan French on 27.08.24.
//

import Foundation
import SwiftUI

protocol Animatable {
    var currentAnimationFrame:Int {get set}
    func animate()
}

protocol Moveable {
    static var speed: Int { get }
    var speedCounter:Int {get set}
    
    func move()
}

class SwiftUISprite:ObservableObject {
    var id = UUID()
    var xPos = 0
    var yPos = 0
    var currentAnimationFrame = 0
    @Published
    var position = CGPoint()
    @Published
    var isShowing = false
    var frameSize: CGSize = CGSize()
    @Published
    var currentFrame:ImageResource = ImageResource(name: "", bundle: .main)
    @Published
    var currentImage:UIImage = UIImage()

    var gridOffsetX = 0
    var gridOffsetY = 0
    var moveDistance = 0.0
    var speedCounter: Int = 0
    var moveCounter = 0

    init(xPos: Int, yPos: Int, frameSize: CGSize) {
        self.xPos = xPos
        self.yPos = yPos
        self.frameSize = frameSize
        position = calcPosition()
    }
    
    func calcPosition() -> CGPoint {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            let pos = CGPoint(x: Double(xPos) * screenData.assetDimension + (screenData.assetDimension / 2),y:Double(yPos) * screenData.assetDimension + (screenData.assetDimension / 2))
            return pos
        }
        return CGPoint()
    }
    
    func setPosition(xPos:Int, yPos:Int) {
        self.xPos = xPos
        self.yPos = yPos
        position = calcPosition()
    }

    func getTile(name:String,pos:Int) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        let rect = CGRect(x: pos * 16, y: 0, width: 16, height: 16)
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    func getTile(name:String,pos:Int,y:Int) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        let rect = CGRect(x: pos * 16, y: y * 16, width: 16, height: 16)
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
