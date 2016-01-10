import UIKit

class SceneInfo: NSObject {
    var birthRate:CGFloat
    var emitterPosition:CGFloat
    var audioFile:String
    var audioFileType:String
    
    init(birthRate:CGFloat, emitterPosition:CGFloat, audioFile:String, audioFileType:String){
        self.birthRate = birthRate
        self.emitterPosition = emitterPosition
        self.audioFile = audioFile
        self.audioFileType = audioFileType
        
    }
}