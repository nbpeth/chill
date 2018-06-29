
import UIKit

@IBDesignable class ActionButton: UIControl {
    
    @IBInspectable var color:UIColor?
    
    override func draw(_ rect: CGRect) {
        let recty = CGRect(x: 0,y: 0, width: rect.height/2, height: rect.width/2)
        let center = CGPoint(x:rect.width/2, y: rect.height/2)
        recty.offsetBy(dx: center.x/2, dy: center.y/2)
        let path = UIBezierPath(ovalIn: rect)
        
        color?.setFill()
        
        path.fill()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
   

    
}
