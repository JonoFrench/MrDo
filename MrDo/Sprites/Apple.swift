//
//  Apple.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import Foundation
import SwiftUI
import UIKit

final class Apple:SwiftUISprite, ObservableObject {
    @Published
    var collected = false
    
    init(xPos: Int, yPos:Int) {
        
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 30, height:  30))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 64, height:  64))
#endif
        currentImage = getTile(name: "Apple", pos: 1)!
    }
    
    
}
