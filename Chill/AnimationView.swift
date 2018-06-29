
import UIKit
import SpriteKit

class AnimationView: UIView {

    var emitter:SKEmitterNode!
    
    override func draw(_ rect: CGRect) {
        loadSprite(rect: rect)
    }
    
    func loadSprite(rect:CGRect){
        let skView:SKView = SKView(frame: rect)
        let skScene:SKScene = SKScene(size: skView.frame.size)
        skScene.scaleMode = .aspectFill
        skView.allowsTransparency = true
        skScene.backgroundColor = UIColor.clear
        self.emitter.removeFromParent()
        skScene.addChild(emitter)
        
        skView.presentScene(skScene)

        super.self().insertSubview(skView, belowSubview: super.self())
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
