//
//  GameManager+Levels.swift
//  MrDo
//
//  Created by Jonathan French on 13.10.24.
//

import Foundation
import SwiftUI

extension GameManager {
    
    func setIntroScreenData() {
        screenData.levelData.setIntroScreen()
        mrDo.setup(xPos: 2, yPos: 5)
        appleArray.apples.removeAll()
        appleArray.add(xPos: 6, yPos: 5)
        appleArray.add(xPos: 7, yPos: 6)
        appleArray.add(xPos: 9, yPos: 6)
        resetIntroScreen()
    }
    
    func resetIntroScreen() {
        mrDo.hasBall = true
        introBall = false
        ball.thrown = false
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        extraMonsterArray.addIntro(xPos: 9, yPos: 5, letterPos: introLetter)
        introLetter += 1
        if introLetter == 5 { introLetter = 0 }
    }
    
    func clearIntroScreenData() {
        timer.invalidate()
        extraMonsterArray.monsters.removeAll()
        ball.thrown = false
    }
    
    func setDataForLevel(level: Int) {
        resetLevelState()
        configureLevel(level)
    }
    
    func increaseLevel() {
        screenData.screenLevel += 1
        screenData.actualLevel += 1
        screenData.gameLevel += 1
    }
    
    private func resetLevelState() {
        redMonsterArray.monsters.removeAll()
        extraMonsterArray.monsters.removeAll()
        appleArray.apples.removeAll()
        center = Center()
        mrDo.setup(xPos: 5, yPos: 12)
    }
    
    private func configureLevel(_ level: Int) {
        screenData.levelData.setLevelData(screenLevel: screenData.screenLevel,gameLevel: screenData.gameLevel)
        
        switch level {
        case 1...30:
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
            10: level10Data,
            11: level11Data,
            12: level12Data,
            13: level13Data,
            14: level14Data,
            15: level15Data,
            16: level16Data,
            17: level17Data,
            18: level18Data,
            19: level19Data,
            20: level20Data,
            21: level21Data,
            22: level22Data,
            23: level23Data,
            24: level24Data,
            25: level25Data,
            26: level26Data,
            27: level27Data,
            28: level28Data,
            29: level29Data,
            30: level30Data,
        ]
        levelConfigurations[level]?()
    }

    private func level1Data(){
        appleArray.add(xPos: 2, yPos: 0)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 2, yPos: 5)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level2Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 6, yPos: 3)
        appleArray.add(xPos: 3, yPos: 4)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level3Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 7, yPos: 1)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 3, yPos: 7)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level4Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 5, yPos: 2)
        appleArray.add(xPos: 2, yPos: 3)
        appleArray.add(xPos: 6, yPos: 4)
        appleArray.add(xPos: 6, yPos: 5)
        appleArray.add(xPos: 10, yPos: 7)
    }
    private func level5Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 2)
        appleArray.add(xPos: 7, yPos: 2)
        appleArray.add(xPos: 3, yPos: 6)
        appleArray.add(xPos: 8, yPos: 6)
        appleArray.add(xPos: 7, yPos: 7)
    }
    private func level6Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 9, yPos: 3)
        appleArray.add(xPos: 3, yPos: 8)
        appleArray.add(xPos: 9, yPos: 9)
    }
    private func level7Data(){
        appleArray.add(xPos: 1, yPos: 1)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 3, yPos: 3)
        appleArray.add(xPos: 2, yPos: 7)
        appleArray.add(xPos: 9, yPos: 8)
    }
    private func level8Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 7, yPos: 3)
        appleArray.add(xPos: 4, yPos: 8)
        appleArray.add(xPos: 7, yPos: 9)
    }
    private func level9Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 2, yPos: 2)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 9, yPos: 2)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 4, yPos: 8)
    }
    private func level10Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 10, yPos: 5)
        appleArray.add(xPos: 6, yPos: 9)
    }
    private func level11Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 2, yPos: 5)
        appleArray.add(xPos: 9, yPos: 5)
        appleArray.add(xPos: 10, yPos: 5)
        appleArray.add(xPos: 2, yPos: 7)
    }
    private func level12Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 6, yPos: 3)
        appleArray.add(xPos: 3, yPos: 4)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level13Data(){
        appleArray.add(xPos: 3, yPos: 2)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 4, yPos: 5)
        appleArray.add(xPos: 6, yPos: 8)
        appleArray.add(xPos: 9, yPos: 8)
    }
    private func level14Data(){
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 5, yPos: 2)
        appleArray.add(xPos: 2, yPos: 3)
        appleArray.add(xPos: 6, yPos: 4)
        appleArray.add(xPos: 6, yPos: 5)
        appleArray.add(xPos: 10, yPos: 7)
    }
    private func level15Data(){
        appleArray.add(xPos: 2, yPos: 1)
        appleArray.add(xPos: 10, yPos: 1)
        appleArray.add(xPos: 6, yPos: 3)
        appleArray.add(xPos: 9, yPos: 6)
        appleArray.add(xPos: 3, yPos: 7)
        appleArray.add(xPos: 6, yPos: 8)
    }
    private func level16Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 8, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 9, yPos: 3)
        appleArray.add(xPos: 3, yPos: 8)
        appleArray.add(xPos: 9, yPos: 9)
    }
    private func level17Data(){
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 3, yPos: 2)
        appleArray.add(xPos: 10, yPos: 4)
        appleArray.add(xPos: 2, yPos: 6)
        appleArray.add(xPos: 1, yPos: 7)
        appleArray.add(xPos: 8, yPos: 7)
    }
    private func level18Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 7, yPos: 3)
        appleArray.add(xPos: 4, yPos: 8)
        appleArray.add(xPos: 7, yPos: 9)
    }
    private func level19Data(){
        appleArray.add(xPos: 7, yPos: 1)
        appleArray.add(xPos: 2, yPos: 2)
        appleArray.add(xPos: 4, yPos: 4)
        appleArray.add(xPos: 8, yPos: 4)
        appleArray.add(xPos: 2, yPos: 8)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level20Data(){
        appleArray.add(xPos: 6, yPos: 1)
        appleArray.add(xPos: 7, yPos: 2)
        appleArray.add(xPos: 2, yPos: 3)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 8, yPos: 6)
        appleArray.add(xPos: 2, yPos: 7)
    }

    private func level21Data(){
        appleArray.add(xPos: 2, yPos: 0)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 9, yPos: 3)
        appleArray.add(xPos: 7, yPos: 4)
        appleArray.add(xPos: 2, yPos: 5)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level22Data(){
        appleArray.add(xPos: 3, yPos: 1)
        appleArray.add(xPos: 7, yPos: 3)
        appleArray.add(xPos: 10, yPos: 3)
        appleArray.add(xPos: 1, yPos: 4)
        appleArray.add(xPos: 7, yPos: 4)
        appleArray.add(xPos: 6, yPos: 8)
    }
    private func level23Data(){
        appleArray.add(xPos: 3, yPos: 2)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 4, yPos: 5)
        appleArray.add(xPos: 6, yPos: 8)
        appleArray.add(xPos: 9, yPos: 8)
    }
    private func level24Data(){
        appleArray.add(xPos: 1, yPos: 0)
        appleArray.add(xPos: 5, yPos: 1)
        appleArray.add(xPos: 10, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 7, yPos: 3)
        appleArray.add(xPos: 4, yPos: 8)
    }
    private func level25Data(){
        appleArray.add(xPos: 2, yPos: 1)
        appleArray.add(xPos: 10, yPos: 1)
        appleArray.add(xPos: 6, yPos: 3)
        appleArray.add(xPos: 9, yPos: 6)
        appleArray.add(xPos: 3, yPos: 7)
        appleArray.add(xPos: 6, yPos: 8)
    }
    private func level26Data(){
        appleArray.add(xPos: 4, yPos: 1)
        appleArray.add(xPos: 7, yPos: 1)
        appleArray.add(xPos: 9, yPos: 2)
        appleArray.add(xPos: 4, yPos: 3)
        appleArray.add(xPos: 8, yPos: 8)
        appleArray.add(xPos: 6, yPos: 9)
    }
    private func level27Data(){
        appleArray.add(xPos: 1, yPos: 1)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 6, yPos: 2)
        appleArray.add(xPos: 3, yPos: 3)
        appleArray.add(xPos: 2, yPos: 7)
        appleArray.add(xPos: 9, yPos: 8)
    }
    private func level28Data(){
        appleArray.add(xPos: 6, yPos: 1)
        appleArray.add(xPos: 4, yPos: 2)
        appleArray.add(xPos: 4, yPos: 3)
        appleArray.add(xPos: 7, yPos: 4)
        appleArray.add(xPos: 3, yPos: 8)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level29Data(){
        appleArray.add(xPos: 6, yPos: 1)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 1, yPos: 3)
        appleArray.add(xPos: 4, yPos: 4)
        appleArray.add(xPos: 9, yPos: 4)
        appleArray.add(xPos: 7, yPos: 8)
    }
    private func level30Data(){
        appleArray.add(xPos: 6, yPos: 1)
        appleArray.add(xPos: 8, yPos: 1)
        appleArray.add(xPos: 2, yPos: 4)
        appleArray.add(xPos: 8, yPos: 6)
        appleArray.add(xPos: 3, yPos: 7)
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
    
    func levelEndImage(type:LevelEndType) -> ImageResource {
        switch type {
        case .cherry:
            ImageResource(name: "Cherry", bundle: .main)
        case .redmonster:
            ImageResource(name: "RedMonster", bundle: .main)
        case .extramonster:
            ImageResource(name: "RedMonster", bundle: .main)
        }
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
            increaseLevel()
            startPlaying()
        }
    }
}
