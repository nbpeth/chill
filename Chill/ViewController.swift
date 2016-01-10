
import UIKit
import SpriteKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var aniView:AnimationView!
    var sceneInfo:[String:SceneInfo]!
    var currentScene:SceneInfo!
    
    @IBOutlet weak var slider: ArcSlider!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var playButton: ActionButton!
    @IBOutlet weak var playGraphic: UIImageView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = Colors.navy

        stowSceneInfo()
        setScene("Shower")
        initAudioPlayer("rain_1", type:"mp3")
    }
    
    func stowSceneInfo(){
        sceneInfo = [String:SceneInfo]()
        sceneInfo.updateValue(SceneInfo(birthRate:1500, emitterPosition:2, audioFile: "rain_1", audioFileType: "mp3"), forKey: "Shower")
        sceneInfo.updateValue(SceneInfo(birthRate:220, emitterPosition:2, audioFile: "fire_1", audioFileType: "mp3"), forKey: "Fire")
        sceneInfo.updateValue(SceneInfo(birthRate:42, emitterPosition:1, audioFile: "ambient", audioFileType: "wav"), forKey: "snow")
    }
    
    func setScene(sceneName:String){
        currentScene = sceneInfo[sceneName]
        aniView?.removeFromSuperview()
        
        aniView = AnimationView(frame: self.view.frame)
        aniView.emitter = SKEmitterNode(fileNamed: sceneName)
        aniView.emitter.position = CGPointMake(self.view.frame.width/2, self.view.frame.height/currentScene.emitterPosition);
        aniView.backgroundColor = UIColor.clearColor()
        aniView.emitter.particleBirthRate = audioPlaying() ? currentScene.birthRate : 0
        self.view.insertSubview(aniView, belowSubview: slider)

        initAudioPlayer(currentScene.audioFile, type:currentScene.audioFileType)
    }
    
    func initAudioPlayer(file:String, type:String){
        let path = NSBundle.mainBundle().pathForResource(file, ofType: type)!
        let url = NSURL(fileURLWithPath: path)
        let audioShouldPlay = audioPlaying()
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer.volume = slider.value
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            
            if(audioShouldPlay){
                audioPlayer.play()
            }
        }
        catch{}
    }
    
    @IBAction func segmentControlHasChanged(sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
            case 0:
                changeTheme(Colors.navy, baseColor: Colors.paleBlue, sliderColor: Colors.mediumBlue, buttonColor:
                    Colors.cobaltSemiTrans, segmentColor: Colors.cyan)
                setScene("Shower")
                updateSegmentTheme()
            

            case 1:
                changeTheme(Colors.cayenne, baseColor: UIColor.orangeColor(), sliderColor: UIColor.redColor(), buttonColor: Colors.brickSemiTrans, segmentColor: UIColor.redColor())
                setScene("Fire")
                updateSegmentTheme()
            
        case 2:
            changeTheme(UIColor.blackColor(), baseColor: Colors.lavender, sliderColor: Colors.violet, buttonColor:
                Colors.deepPurpleSemiTrans, segmentColor: Colors.lightPurple)
            setScene("snow")
            updateSegmentTheme()
            
            
            default:
                break;
        }
    }
    
    @IBAction func sliderValueHasChanged(sender: ArcSlider) {
        adjustVolume()
    }
    
    @IBAction func playButtonWasPressed(sender: ActionButton) {
        toggleAudio()
        
    }
    
    func changeTheme(bgColor:UIColor, baseColor:UIColor, sliderColor:UIColor, buttonColor:UIColor, segmentColor:UIColor){
        self.view.backgroundColor = bgColor
        slider.baseColor = baseColor
        slider.sliderColor = sliderColor
        playButton.color = buttonColor
        segmentControl.tintColor = segmentColor
    }
    
    func updateSegmentTheme(){
        playButton.setNeedsDisplay()
        slider.setNeedsDisplay()
    }
    
    func adjustVolume(){
        audioPlayer.volume = slider.value
    }
    
    func toggleAudio(){
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        
        if(audioPlaying()){
            audioPlayer.stop()
            aniView?.emitter.particleBirthRate = 0
            playGraphic.image = UIImage(named: "ic_play_arrow_2x.png")
            
            mpic.nowPlayingInfo = nil
            activeAudioSession(false)
        }
            
        else{
            audioPlayer.play()
            aniView?.emitter.particleBirthRate = currentScene.birthRate
            playGraphic.image = UIImage(named: "ic_pause_2x.png")
            
            mpic.nowPlayingInfo = [MPMediaItemPropertyTitle:"Chill"]
            activeAudioSession(true)
        }
    }
    
    func activeAudioSession(active:Bool){
        do{
            try AVAudioSession.sharedInstance().setActive(active)
        }
        catch{}
    }
    
    func audioPlaying()->Bool{
        return audioPlayer?.playing == true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) { // *
        switch event!.subtype {
            
        case .RemoteControlTogglePlayPause:
            if audioPlayer.playing { audioPlayer.pause() } else { audioPlayer.play()}
        case .RemoteControlPlay:
            audioPlayer.play()
        case .RemoteControlPause:
            audioPlayer.pause()
        default:
            break
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
}

