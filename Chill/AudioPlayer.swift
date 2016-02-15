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
        let path = NSBundle.mainBundle().pathForResource(audioFile.fileName, ofType: audioFile.fileType)!
        let url = NSURL(fileURLWithPath: path)
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
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
        return audioPlayer?.playing == true ? true : false
    }
    
    func setVolume(volume:Float){
        audioPlayer?.volume = volume
    }
    
    

}
