
import UIKit
import SpriteKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var audioPlayer:AudioPlayer!
    var aniView:AnimationView!
    var sceneInfo:[String:SceneInfo]!
    var currentScene:SceneInfo!
    let mpic = MPNowPlayingInfoCenter.default()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var slider: ArcSlider!
    @IBOutlet weak var playButton: ActionButton!
    @IBOutlet weak var playGraphic: UIImageView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = Colors.navy
        
        stowSceneInfo()
        createAudioPlayer(audioFile: AudioFile(name: "rain_1", type: "mp3"))
        setScene(sceneName: "Shower")
    }
    
    func stowSceneInfo(){
        sceneInfo = [String:SceneInfo]()
        sceneInfo.updateValue(SceneInfo(sceneName:"Shower", birthRate:1500, emitterPosition:2, audioFile: AudioFile(name: "rain_1", type: "mp3")), forKey: "Shower")
        sceneInfo.updateValue(SceneInfo(sceneName:"Fire",birthRate:220, emitterPosition:2, audioFile: AudioFile(name: "fire_1", type: "mp3")), forKey: "Fire")
        sceneInfo.updateValue(SceneInfo(sceneName:"snow",birthRate:42, emitterPosition:1, audioFile: AudioFile(name: "ambient", type: "wav")), forKey: "snow")
    }
    
    func setScene(sceneName:String){
        currentScene = sceneInfo[sceneName]
        aniView?.removeFromSuperview()
        
        aniView = AnimationView(frame: self.view.frame)
        aniView.emitter = SKEmitterNode(fileNamed: sceneName)
        
        aniView.emitter.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/currentScene.emitterPosition)
        
        aniView.backgroundColor = UIColor.clear
        aniView.emitter.particleBirthRate = audioPlayer.audioPlaying() ? currentScene.birthRate : 0
        self.view.insertSubview(aniView, belowSubview: slider)

        createAudioPlayer(audioFile: currentScene.audioFile)
    }

    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex
        {
            case 0:
                changeTheme(bgColor: Colors.navy, baseColor: Colors.paleBlue, sliderColor: Colors.mediumBlue, buttonColor:
                    Colors.cobaltSemiTrans, segmentColor: Colors.cyan)
                setScene(sceneName: "Shower")
                updateSegmentTheme()
            

            case 1:
                changeTheme(bgColor: Colors.cayenne, baseColor: UIColor.orange, sliderColor: UIColor.red, buttonColor: Colors.brickSemiTrans, segmentColor: UIColor.red)
                setScene(sceneName: "Fire")
                updateSegmentTheme()
            
            case 2:
                changeTheme(bgColor: UIColor.black, baseColor: Colors.lavender, sliderColor: Colors.violet, buttonColor:
                    Colors.deepPurpleSemiTrans, segmentColor: Colors.lightPurple)
                setScene(sceneName: "snow")
                updateSegmentTheme()
            
            
                default:
                    break;
        }
    }
    @IBAction func playButtonWasPressed(_ sender: Any) {
        toggleAudio()
    }
    
    @IBAction func sliderValueHasChanged(_ sender: Any) {
        adjustVolume()
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
        audioPlayer.setVolume(volume: slider.value)
    }
    
    func toggleAudio(){
        if(audioPlayer.audioPlaying()){
            stopAudio(mpic: mpic)
        }
            
        else{
            playAudioWithCurrentSettings(mpic: mpic)
        }
    }
    
    func stopAudio(mpic:MPNowPlayingInfoCenter){
        audioPlayer.stop()
        resetUI()
        
        mpic.nowPlayingInfo = nil
        activeAudioSession(active: false)
    }
    
    func playAudioWithCurrentSettings(mpic:MPNowPlayingInfoCenter){
        audioPlayer.play()
        aniView?.emitter.particleBirthRate = currentScene.birthRate
        playGraphic.image = UIImage(named: "ic_pause_2x.png")
        
        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle:"Chill"]
        activeAudioSession(active: true)
    }
    
    func activeAudioSession(active:Bool){
        do{
            try AVAudioSession.sharedInstance().setActive(active)
        }
        catch{}
    }
    
    func checkState(){
        if(AVAudioSession.sharedInstance().isOtherAudioPlaying || audioPlayer?.shouldPlay == false){
            resetUI()
            
            return
        }
        
        playAudioWithCurrentSettings(mpic: mpic)
        
    }
    
    func resetUI(){
        aniView?.emitter.particleBirthRate = 0
        playGraphic.image = UIImage(named: "ic_play_arrow_2x.png")
    }
    
    func shouldPlay() -> Bool{
        return audioPlayer?.audioPlaying() == true ? true : false
    }
    
    func createAudioPlayer(audioFile: AudioFile){
        audioPlayer = AudioPlayer(file: audioFile, sliderValue: slider.value, shouldPlay: shouldPlay())
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        switch event!.subtype {
            
        case .remoteControlTogglePlayPause:
            if audioPlayer.audioPlaying() { audioPlayer.pause() } else { audioPlayer.play()}
        case .remoteControlPlay:
            audioPlayer.play()
        case .remoteControlPause:
            audioPlayer.pause()
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()

        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    
//    override func canBecomeFirstResponder() -> Bool {
//        return true
//    }
//
}

