//
//  GameManager+Levels.swift
//  MrDo
//
//  Created by Jonathan French on 13.10.24.
//

import Foundation

extension GameManager {
   
    func setDataForLevel() {
        appleArray.apples.removeAll()
        center = Center(xPos: 5, yPos: 6)
        gameScreen.levelData.setLevelData(level: gameScreen.level)
        switch gameScreen.level {
        case 1: level1Data()
        case 2: level2Data()
        case 3: level3Data()
        case 4: level4Data()
        case 5: level5Data()
        case 6: level6Data()
        case 7: level7Data()
        case 8: level8Data()
        case 9: level9Data()
        case 10: level10Data()

        default:
            level1Data()
        }
    }
    
    func level1Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 2, yPos: 0)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 2, yPos: 5)
        appleArray.add(xPos: 7, yPos: 8)
    }
 
    func level2Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 6, yPos: 3)
        appleArray.add(xPos: 3, yPos: 4)
        appleArray.add(xPos: 7, yPos: 8)
    }

    func level3Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 7, yPos: 1)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 3, yPos: 7)
        appleArray.add(xPos: 7, yPos: 8)
    }
    
    func level4Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 5, yPos: 2)
        appleArray.add(xPos: 2, yPos: 3)
        appleArray.add(xPos: 6, yPos: 4)
        appleArray.add(xPos: 6, yPos: 5)
        appleArray.add(xPos: 10, yPos: 7)
    }

    func level5Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 2)
        appleArray.add(xPos: 7, yPos: 2)
        appleArray.add(xPos: 3, yPos: 6)
        appleArray.add(xPos: 8, yPos: 6)
        appleArray.add(xPos: 7, yPos: 7)
    }

    func level6Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 9, yPos: 3)
        appleArray.add(xPos: 3, yPos: 8)
        appleArray.add(xPos: 9, yPos: 9)
    }
    func level7Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 1, yPos: 1)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 3, yPos: 3)
        appleArray.add(xPos: 2, yPos: 7)
        appleArray.add(xPos: 9, yPos: 8)
    }
    func level8Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 7, yPos: 3)
        appleArray.add(xPos: 4, yPos: 8)
        appleArray.add(xPos: 7, yPos: 9)
    }
    func level9Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 2, yPos: 2)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 9, yPos: 2)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 4, yPos: 8)
    }
    func level10Data(){
        mrDo.setup(xPos: 5, yPos: 12)
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 10, yPos: 5)
        appleArray.add(xPos: 6, yPos: 9)
    }

}
