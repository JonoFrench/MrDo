//
//  ScreenData.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import Foundation
import SwiftUI

final class ScreenData:ObservableObject {
    let soundFX:SoundFX = SoundFX()
    @Published
    var levelData = LevelData()
    let screenDimensionX:Int = 12
    let screenDimensionY:Int = 13
    var assetDimension = 0.0
    var assetDimensionStep = 0.0
    var gameSize = CGSize()
    var screenSize = CGSize()
    @Published
    var level:Int = 1 {
        didSet {
            if level > 10 {
                level = 1
            }
        }
    }
    var gameLevel:Int = 1
    var levelEnd = false
    var gameOver = false
}

class ServiceLocator {
    static let shared = ServiceLocator()
    private init() {}
    
    private var services: [String: AnyObject] = [:]
    
    func register<T>(service: T) {
        let key = "\(T.self)"
        services[key] = service as AnyObject
    }
    
    func resolve<T>() -> T? {
        let key = "\(T.self)"
        return services[key] as? T
    }
}
