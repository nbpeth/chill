import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    var audioPlayer:AVAudioPlayer?
    var audioFile:AudioFile
    var sliderValue:Float
    var shouldPlay:Bool
    
    init(file:AudioFile, sliderValue:Float, shouldPlay:Bool){
        self.audioFile = file
        self.sliderValue = sliderValue
        self.shouldPlay = shouldPlay
        
        super.init()
        self.initAudioPlayer()
    }
    
    func initAudioPlayer(){
        guard let path = Bundle.main.path(forResource: audioFile.name, ofType: audioFile.type) else { return }
        let url = URL(fileURLWithPath: path)
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = sliderValue
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            
            if(shouldPlay){
                audioPlayer?.play()
            }
        }
        catch{}
    }
    
    func play(){
        audioPlayer?.play()
        shouldPlay = true
    }
    
    func pause(){
        audioPlayer?.pause()
        shouldPlay = false
    }
    
    func stop(){
        audioPlayer?.stop()
        shouldPlay = false
    }
    
    func audioPlaying()->Bool{
        return audioPlayer?.isPlaying == true ? true : false
    }
    
    func setVolume(volume:Float){
        audioPlayer?.volume = volume
    }
    
    

}
