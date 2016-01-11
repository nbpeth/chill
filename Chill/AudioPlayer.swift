import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    var audioPlayer:AVAudioPlayer?
    var file:String
    var type:String
    var sliderValue:Float
    
    init(file:String, type:String, sliderValue:Float){
        self.file = file
        self.type = type
        self.sliderValue = sliderValue
        
        super.init()
        self.initAudioPlayer()
    }
    
    func initAudioPlayer(){
        let path = NSBundle.mainBundle().pathForResource(file, ofType: type)!
        let url = NSURL(fileURLWithPath: path)
        let audioShouldPlay = audioPlaying()
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer?.volume = sliderValue
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            
            if(audioShouldPlay){
                audioPlayer?.play()
            }
        }
        catch{}
    }
    
    func play(){
        audioPlayer?.play()
    }
    
    func pause(){
        audioPlayer?.pause()
    }
    
    func stop(){
        audioPlayer?.stop()
    }
    
    func audioPlaying()->Bool{
        return (audioPlayer != nil) ? audioPlayer!.playing : false
    }
    
    func setVolume(volume:Float){
        audioPlayer?.volume = volume
    }
    
    

}
