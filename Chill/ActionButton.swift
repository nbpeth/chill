
import UIKit

@IBDesignable class ActionButton: UIControl {
    
    @IBInspectable var color:UIColor
    
    override func drawRect(rect: CGRect) {
        var recty = CGRectMake(0,0,rect.height/2,rect.width/2)
        var center = CGPoint(x:rect.width/2, y: rect.height/2)
        recty.offsetInPlace(dx: center.x/2, dy: center.y/2)
        let path = UIBezierPath(ovalInRect: rect)
        
        color.setFill()
        
        path.fill()
        
//        let circle = CAShapeLayer()
//        let center = CGPoint(x:rect.width/2, y: rect.height/2)
//        let radius: CGFloat = max(rect.width/2, rect.height/2)
//        let path = UIBezierPath(arcCenter:center, radius: radius * 0.75, startAngle:CGFloat(M_PI), endAngle: CGFloat(M_PI+0.00001), clockwise: false).CGPath
//        
//        circle.path = path
//        circle.shadowColor = UIColor.blackColor().CGColor
//        circle.shadowOffset = CGSize(width: 3, height: 3)
//        circle.fillColor = color.CGColor
//        circle.shadowRadius = CGFloat(5)
//        circle.shadowOpacity = 0.80
//        self.layer.addSublayer(circle)
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