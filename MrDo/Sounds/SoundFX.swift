//
//  SoundFX.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import Foundation
import AVFoundation

// MARK: - Sound Types
private enum SoundType {
    case effect
    case background
    case music
    
    var volume: Float {
        switch self {
        case .effect: return GameConstants.Sound.effectsVolume
        case .background: return GameConstants.Sound.backgroundVolume
        case .music: return GameConstants.Sound.musicVolume
        }
    }
}

// MARK: - Sound Asset Names
private enum SoundAsset {
    static let roundClear = "RoundClear"
    static let start = "Start"
    static let background = "BGM"
    static let backgroundFast = "BGMFaster"
    static let backgroundAlpha = "BGMAlpha"
    static let backgroundMuncher = "BGMMuncher"
    static let cherryBase = "Cherry"  // Cherry1-8 will append number
    static let appleDrop = "AppleDrop"
    static let appleBreak = "AppleBreak"
    static let progress = "Progress"
    static let gameOver = "GameOver"
    static let loseLife = "LoseLife"
    static let nameEntry = "NameEntry"
    static let ballHit = "BallHit"
    static let ballReset = "BallReset"
    static let extraLife = "ExtraLife"
}

final class SoundFX {
    // MARK: - Properties
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private let audioExtension = "m4a"
    
    // MARK: - Initialization
    init() {
        setupAudioSession()
        loadSoundAssets()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    private func loadSoundAssets() {
        // Load effects
        loadSound(SoundAsset.roundClear, type: .effect)
        loadSound(SoundAsset.start, type: .effect)
        loadSound(SoundAsset.appleDrop, type: .effect)
        loadSound(SoundAsset.appleBreak, type: .effect)
        loadSound(SoundAsset.progress, type: .effect)
        loadSound(SoundAsset.gameOver, type: .effect)
        loadSound(SoundAsset.loseLife, type: .effect)
        loadSound(SoundAsset.nameEntry, type: .effect)
        loadSound(SoundAsset.ballHit, type: .effect)
        loadSound(SoundAsset.ballReset, type: .effect)
        loadSound(SoundAsset.extraLife, type: .effect)
        
        // Load cherry sounds
        for i in 1...8 {
            loadSound("\(SoundAsset.cherryBase)\(i)", type: .effect)
        }
        
        // Load background music
        loadSound(SoundAsset.background, type: .background)
        loadSound(SoundAsset.backgroundFast, type: .background)
        loadSound(SoundAsset.backgroundAlpha, type: .background)
        loadSound(SoundAsset.backgroundMuncher, type: .background)
    }
    
    private func loadSound(_ name: String, type: SoundType) {
        guard let url = Bundle.main.url(forResource: name, withExtension: audioExtension) else {
            print("Failed to find sound file: \(name).\(audioExtension)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            player.volume = type.volume
            audioPlayers[name] = player
        } catch {
            print("Failed to load sound \(name): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Playback Control
    @objc private func play(audioPlayer: AVAudioPlayer) {
        audioPlayer.play()
    }
    
    private func playOnNewThread(_ name: String, loops: Int = 0) {
        guard let player = audioPlayers[name] else { return }
        player.numberOfLoops = loops
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: player)
    }
    
    private func stop(_ name: String) {
        audioPlayers[name]?.stop()
    }
    
    // MARK: - Public Interface
    func roundClear() { playOnNewThread(SoundAsset.roundClear) }
    func startSound() { playOnNewThread(SoundAsset.start) }
    func nameEntrySound() { playOnNewThread(SoundAsset.nameEntry) }
    func loseLifeSound() { playOnNewThread(SoundAsset.loseLife) }
    func progressSound() { playOnNewThread(SoundAsset.progress) }
    func extraLifeSound() { playOnNewThread(SoundAsset.extraLife) }
    func gameOverSound() { playOnNewThread(SoundAsset.gameOver) }
    func ballHitSound() { playOnNewThread(SoundAsset.ballHit) }
    func ballResetSound() { playOnNewThread(SoundAsset.ballReset) }
    
    func cherrySound(count: Int) {
        let soundName = "\(SoundAsset.cherryBase)\(min(max(count, 1), 8))"
        playOnNewThread(soundName)
    }
    
    // MARK: - Background Music
    func backgroundSound() { playOnNewThread(SoundAsset.background, loops: -1) }
    func backgroundFastSound() { playOnNewThread(SoundAsset.backgroundFast, loops: -1) }
    func backgroundAlphaSound() { playOnNewThread(SoundAsset.backgroundAlpha, loops: -1) }
    func backgroundMuncherSound() { playOnNewThread(SoundAsset.backgroundMuncher, loops: -1) }
    
    func backgroundSoundStop() { stop(SoundAsset.background) }
    func backgroundFastSoundStop() { stop(SoundAsset.backgroundFast) }
    func backgroundAlphaSoundStop() { stop(SoundAsset.backgroundAlpha) }
    func backgroundMuncherSoundStop() { stop(SoundAsset.backgroundMuncher) }
    
    func backgroundStopAll() {
        [SoundAsset.background,
         SoundAsset.backgroundFast,
         SoundAsset.backgroundAlpha,
         SoundAsset.backgroundMuncher].forEach(stop)
    }
    
    // MARK: - Apple Sounds
    func appleDropSound() { playOnNewThread(SoundAsset.appleDrop) }
    func appleBreakSound() { playOnNewThread(SoundAsset.appleBreak) }
    func appleDropSoundStop() { stop(SoundAsset.appleDrop) }
}
