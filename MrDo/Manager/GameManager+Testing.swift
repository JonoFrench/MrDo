//
//  GameManager+Testing.swift
//  MrDo
//
//  Created by Jonathan French on 4.11.24.
//

import Foundation

extension GameManager {
#if DEBUG

    func testProgress() {
        ///Testing Progess screen.
        progress = Progress()
        levelScores.append(LevelScores(level: 1, time: Int(45),levelScore: 1000,endType: .cherry))
        levelScores.append(LevelScores(level: 2, time: Int(83),levelScore: 2500,endType: .redmonster))
        levelScores.append(LevelScores(level: 10, time: Int(96),levelScore: 4600,endType: .redmonster))
        gameState = .progress
        screenData.soundFX.progressSound()
    }
    
    func testProgress10() {
        /// Testing Progress10
        screenData.screenLevel = 10
        screenData.gameLevel = 10
        screenData.actualLevel = 10
        gameTime = 450
        score = 5678
        progress10()
    }
    
    func testExtraLife() {
        ///Testing Extra screen
        extraCollected = [true,true,true,true,true]
        screenData.soundFX.extraLifeSound()
        extraLife = ExtraLife()
        gameState = .extralife
        extraFlash()
    }
    
    func testLevel(level:Int){
        
    }
    /// Go through and display each level.
    func testShowLevels(){
        gameState = .playing
        setDataForLevel(level: screenData.gameLevel)
        screenData.levelData.objectWillChange.send()
        if screenData.actualLevel < 31 {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(3.0))
                increaseLevel()
                testShowLevels()
            }
        } else {
            gameState = .intro
        }
    }
#endif
}
