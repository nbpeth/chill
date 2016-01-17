import UIKit

@IBDesignable class ArcSlider: UIControl {
    
    @IBInspectable var baseColor: UIColor
    @IBInspectable var sliderColor: UIColor
    @IBInspectable var lineWidth: CGFloat
    
    var value:Float
    var sliderAngle:CGFloat
    let startAngle: CGFloat
    let maxAngle: CGFloat
    
    override func drawRect(rect: CGRect)
    {
        let newSliderColor = transformColor(sliderColor)
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)

        let baseArc = drawArc(center, radius:radius, startAngle:startAngle, endAngle:maxAngle, color:baseColor, shouldDrawShadow:false)
        let sliderArc = drawArc(center, radius:radius, startAngle:startAngle, endAngle:sliderAngle, color:newSliderColor, shouldDrawShadow: true)
        let arcStart = drawArc(center, radius:radius, startAngle:startAngle, endAngle:startAngle, color:UIColor.clearColor(), shouldDrawShadow: false)
        
        let arcLength = findArcLength(arcStart, endPoint: sliderArc, radius: radius, thing: 1)
        let maxArcLength = findArcLength(arcStart, endPoint: baseArc, radius: radius, thing: 1)
        
        let sliderValue = Float(round(100 * (arcLength / maxArcLength))/100)
        
        self.value = sliderValue < 0.03 ? 0 : sliderValue
        
    }
    
    func transformColor(arc:UIColor) -> UIColor {
        let red = transformColorProperty(arc, key:"red")
        let green = transformColorProperty(arc, key:"green")
        let blue = transformColorProperty(arc, key:"blue")
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func transformColorProperty(slider:UIColor, key:String) -> CGFloat {
        return CGFloat((slider.valueForKey(key) as! Float) * value)
    }
    
    func findArcLength(startPoint:CGPoint,endPoint:CGPoint, radius:CGFloat, thing: CGFloat) -> CGFloat{
        let c = sqrt(Square(startPoint.x - endPoint.x) + Square(startPoint.y - endPoint.y))
        let theta = acos(1 - (Square(c) / (2 * Square(radius))))
        
        return radius * theta

    }
    
    func drawArc(center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat, color:UIColor, shouldDrawShadow:Bool) -> CGPoint{
        
        let path = UIBezierPath(arcCenter:center, radius: radius/2.5 - lineWidth/2.5, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        if(shouldDrawShadow == true){
            let ctx = UIGraphicsGetCurrentContext()
            CGContextSetShadowWithColor(ctx, CGSize(width:2,height:2), 4, UIColor.blackColor().CGColor)
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
        
        
        return path.currentPoint
    }
    
    func moveSlider(point:CGPoint){
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let currentDegrees:CGFloat = AngleFromNorth(center, p2: point, flipped: true)
        let maxDegrees = RadiansToDegrees(maxAngle)
        let minDegrees = RadiansToDegrees(startAngle)
        let currentRadians = DegreesToRadians(currentDegrees)
        
        if(currentDegrees >= maxDegrees || currentDegrees <= minDegrees){
            return
        }
        
        sliderAngle = currentRadians
        
        setNeedsDisplay()
        
    }
    
    override init(frame: CGRect)
    {
        
        self.sliderAngle = CGFloat(3 * M_PI_2)
        self.startAngle = CGFloat(M_PI)
        self.maxAngle = CGFloat(M_PI) * 2
        self.lineWidth = CGFloat(10)
        self.baseColor = UIColor.blackColor()
        self.sliderColor = UIColor.blueColor()
        self.value = 0.70
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.sliderAngle = CGFloat(3 * M_PI_2)
        self.startAngle = CGFloat(M_PI)
        self.maxAngle = CGFloat(M_PI) * 2
        self.lineWidth = CGFloat(10)
        self.baseColor = UIColor.blackColor()
        self.sliderColor = UIColor.blueColor()
        self.value = 0.70
        
        super.init(coder: aDecoder)
        
    }
    
    func AngleFromNorth(p1:CGPoint , p2:CGPoint , flipped:Bool) -> CGFloat {
        var v:CGPoint  = CGPointMake(p2.x - p1.x, p2.y - p1.y)
        let vmag:CGFloat = Square(Square(v.x) + Square(v.y))
        var result:CGFloat = 0.0
        v.x /= vmag;
        v.y /= vmag;
        let radians = CGFloat(atan2(v.y,v.x))
        result = RadiansToDegrees(radians)
        return (result >= 0  ? result : result + 360.0);
    }
    
    func DegreesToRadians (value:CGFloat) -> CGFloat {
        return value * CGFloat(M_PI) / 180.0
    }
    
    func RadiansToDegrees (value:CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(M_PI)
    }
    
    func Square (value:CGFloat) -> CGFloat {
        return value * value
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        let point = touch.locationInView(self)
        self.moveSlider(point)
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }
    
    //    func measureArcLength(radius: CGFloat, startPoint: CGPoint, endPoint: CGPoint) -> CGFloat{
    //        let delta = getAngleDelta()
    //        let theta = getTheta(delta)
    //        let thing = yAtTheta(radius, theta: theta)
    //
    //        return findArcLength(startPoint, endPoint: endPoint, radius: radius, thing: thing)
    //
    //    }
    //
    //    func getAngleDelta() -> CGFloat{
    //        return DegreesToRadians(180) - startAngle
    //
    //    }
    //
    //    func getTheta(delta:CGFloat) -> CGFloat{
    //        return sliderAngle + delta
    //    }
    //
    //    func yAtTheta(radius:CGFloat, theta:CGFloat) -> CGFloat{
    //        return radius * sin(theta)
    //    }


}
