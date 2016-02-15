import UIKit

class SceneInfo: NSObject {
    var birthRate:CGFloat
    var emitterPosition:CGFloat
    var audioFile:AudioFile
    var sceneName:String
    
    
    init(sceneName:String, birthRate:CGFloat, emitterPosition:CGFloat, audioFile:AudioFile){
        self.sceneName = sceneName
        self.birthRate = birthRate
        self.emitterPosition = emitterPosition
        self.audioFile = audioFile
        
    }
}
