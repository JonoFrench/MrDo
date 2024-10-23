//
//  SoundFX.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import Foundation
import AVFoundation

final class SoundFX {
    
    private var roundClearAudioPlayer: AVAudioPlayer?
    private var startAudioPlayer: AVAudioPlayer?
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var cherry1AudioPlayer: AVAudioPlayer?
    private var cherry2AudioPlayer: AVAudioPlayer?
    private var cherry3AudioPlayer: AVAudioPlayer?
    private var cherry4AudioPlayer: AVAudioPlayer?
    private var cherry5AudioPlayer: AVAudioPlayer?
    private var cherry6AudioPlayer: AVAudioPlayer?
    private var cherry7AudioPlayer: AVAudioPlayer?
    private var cherry8AudioPlayer: AVAudioPlayer?
    private var appleDropAudioPlayer: AVAudioPlayer?
    private var appleBreakAudioPlayer: AVAudioPlayer?
    private var progressAudioPlayer: AVAudioPlayer?
    private var gameOverAudioPlayer: AVAudioPlayer?
    private var loseLifeAudioPlayer: AVAudioPlayer?
    private var nameEntryAudioPlayer: AVAudioPlayer?
    private var ballHitAudioPlayer: AVAudioPlayer?
    private var ballResetAudioPlayer: AVAudioPlayer?

    private var backGroundFastAudioPlayer: AVAudioPlayer?
    private var backGroundMuncherAudioPlayer: AVAudioPlayer?
    private var backGroundAlphaAudioPlayer: AVAudioPlayer?
    private var endLevelAudioPlayer: AVAudioPlayer?
    
    private lazy var roundClearurl = Bundle.main.url(forResource: "RoundClear", withExtension: "m4a")
    private lazy var starturl = Bundle.main.url(forResource: "Start", withExtension: "m4a")
    private lazy var backgroundurl = Bundle.main.url(forResource: "BGM", withExtension: "m4a")
    private lazy var cherry1url = Bundle.main.url(forResource: "Cherry1", withExtension: "m4a")
    private lazy var cherry2url = Bundle.main.url(forResource: "Cherry2", withExtension: "m4a")
    private lazy var cherry3url = Bundle.main.url(forResource: "Cherry3", withExtension: "m4a")
    private lazy var cherry4url = Bundle.main.url(forResource: "Cherry4", withExtension: "m4a")
    private lazy var cherry5url = Bundle.main.url(forResource: "Cherry5", withExtension: "m4a")
    private lazy var cherry6url = Bundle.main.url(forResource: "Cherry6", withExtension: "m4a")
    private lazy var cherry7url = Bundle.main.url(forResource: "Cherry7", withExtension: "m4a")
    private lazy var cherry8url = Bundle.main.url(forResource: "Cherry8", withExtension: "m4a")
    private lazy var appleBreakurl = Bundle.main.url(forResource: "AppleBreak", withExtension: "m4a")
    private lazy var appleDropurl = Bundle.main.url(forResource: "AppleDrop", withExtension: "m4a")
    private lazy var progressurl = Bundle.main.url(forResource: "Progress", withExtension: "m4a")
    private lazy var gameOverurl = Bundle.main.url(forResource: "GameOver", withExtension: "m4a")
    private lazy var loseLifeurl = Bundle.main.url(forResource: "LoseLife", withExtension: "m4a")
    private lazy var nameEntryurl = Bundle.main.url(forResource: "NameEntry", withExtension: "m4a")
    private lazy var ballHiturl = Bundle.main.url(forResource: "BallHit", withExtension: "m4a")
    private lazy var ballReseturl = Bundle.main.url(forResource: "BallReset", withExtension: "m4a")

    private lazy var backgroundFasturl = Bundle.main.url(forResource: "BGMFaster", withExtension: "m4a")
    private lazy var backgroundAlphaurl = Bundle.main.url(forResource: "BGMAlpha", withExtension: "m4a")
    private lazy var backgroundMuncherurl = Bundle.main.url(forResource: "BGMMuncher", withExtension: "m4a")

    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            roundClearAudioPlayer = try AVAudioPlayer(contentsOf: roundClearurl!, fileTypeHint: AVFileType.m4a.rawValue)
            startAudioPlayer = try AVAudioPlayer(contentsOf: starturl!, fileTypeHint: AVFileType.m4a.rawValue)
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: backgroundurl!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry1AudioPlayer = try AVAudioPlayer(contentsOf: cherry1url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry2AudioPlayer = try AVAudioPlayer(contentsOf: cherry2url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry3AudioPlayer = try AVAudioPlayer(contentsOf: cherry3url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry4AudioPlayer = try AVAudioPlayer(contentsOf: cherry4url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry5AudioPlayer = try AVAudioPlayer(contentsOf: cherry5url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry6AudioPlayer = try AVAudioPlayer(contentsOf: cherry6url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry7AudioPlayer = try AVAudioPlayer(contentsOf: cherry7url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry8AudioPlayer = try AVAudioPlayer(contentsOf: cherry8url!, fileTypeHint: AVFileType.m4a.rawValue)
            appleDropAudioPlayer = try AVAudioPlayer(contentsOf: appleDropurl!, fileTypeHint: AVFileType.m4a.rawValue)
            appleBreakAudioPlayer = try AVAudioPlayer(contentsOf: appleBreakurl!, fileTypeHint: AVFileType.m4a.rawValue)
            progressAudioPlayer = try AVAudioPlayer(contentsOf: progressurl!, fileTypeHint: AVFileType.m4a.rawValue)
            loseLifeAudioPlayer = try AVAudioPlayer(contentsOf: loseLifeurl!, fileTypeHint: AVFileType.m4a.rawValue)
            gameOverAudioPlayer = try AVAudioPlayer(contentsOf: gameOverurl!, fileTypeHint: AVFileType.m4a.rawValue)
            nameEntryAudioPlayer = try AVAudioPlayer(contentsOf: nameEntryurl!, fileTypeHint: AVFileType.m4a.rawValue)
            ballHitAudioPlayer = try AVAudioPlayer(contentsOf: ballHiturl!, fileTypeHint: AVFileType.m4a.rawValue)
            ballResetAudioPlayer = try AVAudioPlayer(contentsOf: ballReseturl!, fileTypeHint: AVFileType.m4a.rawValue)
            backGroundFastAudioPlayer = try AVAudioPlayer(contentsOf: backgroundFasturl!, fileTypeHint: AVFileType.m4a.rawValue)
            backGroundAlphaAudioPlayer = try AVAudioPlayer(contentsOf: backgroundAlphaurl!, fileTypeHint: AVFileType.m4a.rawValue)
            backGroundMuncherAudioPlayer = try AVAudioPlayer(contentsOf: backgroundMuncherurl!, fileTypeHint: AVFileType.m4a.rawValue)

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func play(audioPlayer:AVAudioPlayer){
        audioPlayer.play()
    }
    
    
    func roundClear(){
        guard let roundClearAudioPlayer = roundClearAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: roundClearAudioPlayer)
    }
    
    func startSound(){
        guard let startAudioPlayer = startAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: startAudioPlayer)
    }
    
    func nameEntrySound(){
        guard let nameEntryAudioPlayer = nameEntryAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: nameEntryAudioPlayer)
    }

    func loseLifeSound(){
        guard let loseLifeAudioPlayer = loseLifeAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: loseLifeAudioPlayer)
    }
    
    
    func progressSound(){
        guard let progressAudioPlayer = progressAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: progressAudioPlayer)
    }
    
    func backgroundSound(){
        guard let backgroundAudioPlayer = backgroundAudioPlayer else { return }
        backgroundAudioPlayer.numberOfLoops = -1
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: backgroundAudioPlayer)
    }
    func backgroundFastSound(){
        guard let backGroundFastAudioPlayer = backGroundFastAudioPlayer else { return }
        if !backGroundFastAudioPlayer.isPlaying {
            backGroundFastAudioPlayer.numberOfLoops = -1
            Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: backGroundFastAudioPlayer)
        }
    }
    func backgroundAlphaSound(){
        guard let backGroundAlphaAudioPlayer = backGroundAlphaAudioPlayer else { return }
        backGroundAlphaAudioPlayer.numberOfLoops = -1
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: backGroundAlphaAudioPlayer)
    }
    func backgroundMuncherSound(){
        guard let backGroundMuncherAudioPlayer = backGroundMuncherAudioPlayer else { return }
        backGroundMuncherAudioPlayer.numberOfLoops = -1
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: backGroundMuncherAudioPlayer)
    }

    
    func backgroundSoundStop(){
        guard let backgroundAudioPlayer = backgroundAudioPlayer else { return }
        backgroundAudioPlayer.stop()
    }

    func backgroundFastSoundStop(){
        guard let backGroundFastAudioPlayer = backGroundFastAudioPlayer else { return }
        backGroundFastAudioPlayer.stop()
    }

    func backgroundAlphaSoundStop(){
        guard let backGroundAlphaAudioPlayer = backGroundAlphaAudioPlayer else { return }
        backGroundAlphaAudioPlayer.stop()
    }
    
    func backgroundMuncherSoundStop(){
        guard let backGroundMuncherAudioPlayer = backGroundMuncherAudioPlayer else { return }
        backGroundMuncherAudioPlayer.stop()
    }
    func backgroundStopAll() {
        backgroundSoundStop()
        backgroundFastSoundStop()
        backgroundAlphaSoundStop()
        backgroundMuncherSoundStop()
    }
    
    
    func cherrySound(count:Int){
        switch count {
        case 1:
            cherrySound1()
        case 2:
            cherrySound2()
        case 3:
            cherrySound3()
        case 4:
            cherrySound4()
        case 5:
            cherrySound5()
        case 6:
            cherrySound6()
        case 7:
            cherrySound7()
        case 8:
            cherrySound8()
        default:
            cherrySound1()
        }
    }
    
    func appleDropSound(){
        guard let appleDropAudioPlayer = appleDropAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: appleDropAudioPlayer)
    }
    
    func appleBreakSound(){
        guard let appleBreakAudioPlayer = appleBreakAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: appleBreakAudioPlayer)
    }
    
    func appleDropSoundStop(){
        guard let appleDropAudioPlayer = appleDropAudioPlayer else { return }
        appleDropAudioPlayer.stop()
    }
    
    func cherrySound1(){
        guard let cherry1AudioPlayer = cherry1AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry1AudioPlayer)
    }
    func cherrySound2(){
        guard let cherry2AudioPlayer = cherry2AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry2AudioPlayer)
    }
    func cherrySound3(){
        guard let cherry3AudioPlayer = cherry3AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry3AudioPlayer)
    }
    func cherrySound4(){
        guard let cherry4AudioPlayer = cherry4AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry4AudioPlayer)
    }
    func cherrySound5(){
        guard let cherry5AudioPlayer = cherry5AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry5AudioPlayer)
    }
    func cherrySound6(){
        guard let cherry6AudioPlayer = cherry6AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry6AudioPlayer)
    }
    func cherrySound7(){
        guard let cherry7AudioPlayer = cherry7AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry7AudioPlayer)
    }
    func cherrySound8(){
        guard let cherry8AudioPlayer = cherry8AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry8AudioPlayer)
    }
    func gameOverSound(){
        guard let gameOverAudioPlayer = gameOverAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: gameOverAudioPlayer)
    }
    func ballHitSound(){
        guard let ballHitAudioPlayer = ballHitAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: ballHitAudioPlayer)
    }
    func ballResetSound(){
        guard let ballResetAudioPlayer = ballResetAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: ballResetAudioPlayer)
    }
}
