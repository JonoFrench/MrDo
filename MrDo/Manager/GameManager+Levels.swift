//
//  GameManager+Levels.swift
//  MrDo
//
//  Created by Jonathan French on 13.10.24.
//

import Foundation

extension GameManager {
    
    func setDataForLevel(level: Int) {
        resetLevelState()
        configureLevel(level)
    }
    
    private func resetLevelState() {
        appleArray.apples.removeAll()
        center = Center()
        mrDo.setup(xPos: 5, yPos: 12)
    }
    
    private func configureLevel(_ level: Int) {
        screenData.levelData.setLevelData(level: level)
        
        switch level {
        case 1...10:
            configureLevelData(for: level)
        default:
            configureLevelData(for: 1)
        }
    }
    
    private func configureLevelData(for level: Int) {
        let levelConfigurations: [Int: () -> Void] = [
            1: level1Data,
            2: level2Data,
            3: level3Data,
            4: level4Data,
            5: level5Data,
            6: level6Data,
            7: level7Data,
            8: level8Data,
            9: level9Data,
            10: level10Data
        ]
        levelConfigurations[level]?()
    }

    func level1Data(){
        appleArray.add(xPos: 2, yPos: 0)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 2, yPos: 5)
        appleArray.add(xPos: 7, yPos: 8)
    }
    
    func level2Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 6, yPos: 3)
        appleArray.add(xPos: 3, yPos: 4)
        appleArray.add(xPos: 7, yPos: 8)
    }
    
    func level3Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 7, yPos: 1)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 3, yPos: 7)
        appleArray.add(xPos: 7, yPos: 8)
    }
    
    func level4Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 5, yPos: 2)
        appleArray.add(xPos: 2, yPos: 3)
        appleArray.add(xPos: 6, yPos: 4)
        appleArray.add(xPos: 6, yPos: 5)
        appleArray.add(xPos: 10, yPos: 7)
    }
    
    func level5Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 2)
        appleArray.add(xPos: 7, yPos: 2)
        appleArray.add(xPos: 3, yPos: 6)
        appleArray.add(xPos: 8, yPos: 6)
        appleArray.add(xPos: 7, yPos: 7)
    }
    
    func level6Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 9, yPos: 3)
        appleArray.add(xPos: 3, yPos: 8)
        appleArray.add(xPos: 9, yPos: 9)
    }
    func level7Data(){
        appleArray.add(xPos: 1, yPos: 1)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 3, yPos: 3)
        appleArray.add(xPos: 2, yPos: 7)
        appleArray.add(xPos: 9, yPos: 8)
    }
    func level8Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 7, yPos: 3)
        appleArray.add(xPos: 4, yPos: 8)
        appleArray.add(xPos: 7, yPos: 9)
    }
    func level9Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 2, yPos: 2)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 9, yPos: 2)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 4, yPos: 8)
    }
    func level10Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 10, yPos: 5)
        appleArray.add(xPos: 6, yPos: 9)
    }
    
    func setExtraFrames() {
        extraFrames = [
              screenData.levelData.getTile(name: "ExtraMonsters", pos: 0),
              screenData.levelData.getTile(name: "ExtraMonsters", pos: 3),
              screenData.levelData.getTile(name: "ExtraMonsters", pos: 6),
              screenData.levelData.getTile(name: "ExtraMonsters", pos: 9),
              screenData.levelData.getTile(name: "ExtraMonsters", pos: 12)
          ].compactMap { $0 }
    }
    
    /// Move the EXTRA monster along the Header whilst playing.
    func extraHeader() {
        guard gameState == .playing && !extraAppearing else { return }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.extraHeaderDelay))
            extraCurrent += 1
            extraHeader()
        }
    }
    
    /// Extra Life screen. Flash the EXTRA box at the top of the screen.
    func extraFlash() {
        guard gameState == .extralife else {
            extraLifeFlashOn = true
            return }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Animation.extraFlashRate))
            extraLifeFlashOn.toggle()
            extraFlash()
        }
    }
    /// After Level 10 We show the Progress10 Screen
    func progress10(){
        gameState = .progress10
        screenData.levelData.setProgress10Data()
        screenData.soundFX.backgroundStopAll()
        screenData.soundFX.progressSound()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.progress10Delay))
            screenData.level += 1
            screenData.gameLevel += 1
            startPlaying()
        }
    }
}
