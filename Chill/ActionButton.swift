
import UIKit

@IBDesignable class ActionButton: UIControl {
    
    @IBInspectable var color:UIColor
    
    override func drawRect(rect: CGRect) {
        var recty = CGRectMake(0,0,rect.height/2,rect.width/2)
        let center = CGPoint(x:rect.width/2, y: rect.height/2)
        recty.offsetInPlace(dx: center.x/2, dy: center.y/2)
        let path = UIBezierPath(ovalInRect: rect)
        
        color.setFill()
        
        path.fill()
        
    }
    
    override init(frame: CGRect) {
        self.color = Colors.cobaltSemiTrans
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.color = Colors.cobaltSemiTrans
        super.init(coder: aDecoder)

    }
    
   

    
}