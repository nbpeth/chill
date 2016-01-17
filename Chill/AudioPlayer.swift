import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    var audioPlayer:AVAudioPlayer?
    var file:String
    var type:String
    var sliderValue:Float
    var shouldPlay:Bool
    
    init(file:String, type:String, sliderValue:Float, shouldPlay:Bool){
        self.file = file
        self.type = type
        self.sliderValue = sliderValue
        self.shouldPlay = shouldPlay
        
        super.init()
        self.initAudioPlayer()
    }
    
    func initAudioPlayer(){
        let path = NSBundle.mainBundle().pathForResource(file, ofType: type)!
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
