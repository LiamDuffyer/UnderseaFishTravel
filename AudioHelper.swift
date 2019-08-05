import UIKit
import AVFoundation
class AudioHelper: NSObject {
    func playSound(audioUrl: NSURL, isAlert: Bool , playFinish: ()->()) {
        let urlCF = audioUrl as CFURL
        var systemSoundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(urlCF, &systemSoundID)
        if isAlert {
            AudioServicesPlayAlertSound(systemSoundID)
        }else {
            AudioServicesPlaySystemSound(systemSoundID)
        }
        playFinish()
    }
    let session = AVAudioSession.sharedInstance()
    var player: AVAudioPlayer?
    var currentURL : NSURL?
    let playFinish = "playFinsh"
    override init() {
        super.init()
        do{
            try session.setCategory(AVAudioSession.Category.playback)
            try session.setActive(true)
        }catch {
            print(error)
            return
        }
    }
    func playMusic(filePath: String) {
        guard let url = NSURL(string: filePath) else {
            return
        }
        do{
            try session.setCategory(AVAudioSession.Category.playback)
        }catch {
            print(error)
            return
        }
        if currentURL == url {
            player?.play()
            return
        }
        do {
            player = try AVAudioPlayer(data: FileManager.default.contents(atPath: filePath)!)
            currentURL = url
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            print("播放成功，文件路径 ==\(url)")
        }catch {
            print(error)
            return
        }
    }
    func pauseCurrentMusic() -> () {
        player?.pause()
    }
    func resumeCurrentMusic() -> () {
        player?.play()
    }
    func seekToTime(time: TimeInterval) -> () {
        player?.currentTime = time
    }
    class func getFormatTime(timeInterval: TimeInterval) -> String {
        let min = Int(timeInterval) / 60
        let sec = Int(timeInterval) % 60
        let timeStr = String(format: "%02d:%02d", min, sec)
        return timeStr
    }
    class func getTimeInterval(formatTime: String) -> TimeInterval {
        let minSec = formatTime.components(separatedBy: ":")
        if minSec.count == 2 {
            let min = TimeInterval(minSec[0]) ?? 0
            let sec = TimeInterval(minSec[1]) ?? 0
            return min * 60 + sec
        }
        return 0
    }
}
extension AudioHelper: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("播放完成")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: playFinish), object: nil)
        self.currentURL = nil
    }
}
