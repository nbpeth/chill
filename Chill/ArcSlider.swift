import UIKit

@IBDesignable class ArcSlider: UIControl {
    
    @IBInspectable var baseColor: UIColor
    @IBInspectable var sliderColor: UIColor
    @IBInspectable var lineWidth: CGFloat
    
    var value:Float
    var sliderAngle:CGFloat
    let startAngle: CGFloat
    let maxAngle: CGFloat
    
    override func draw(_ rect: CGRect)
    {
        let newSliderColor = transformColor(arc: sliderColor)
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)

        let baseArc = drawArc(center: center, radius:radius, startAngle:startAngle, endAngle:maxAngle, color:baseColor, shouldDrawShadow:false)
        let sliderArc = drawArc(center: center, radius:radius, startAngle:startAngle, endAngle:sliderAngle, color:newSliderColor, shouldDrawShadow: true)
        let arcStart = drawArc(center: center, radius:radius, startAngle:startAngle, endAngle:startAngle, color:UIColor.clear, shouldDrawShadow: false)
        
        let arcLength = findArcLength(startPoint: arcStart, endPoint: sliderArc, radius: radius, thing: 1)
        let maxArcLength = findArcLength(startPoint: arcStart, endPoint: baseArc, radius: radius, thing: 1)
        
        let sliderValue = Float(round(100 * (arcLength / maxArcLength))/100)
        
        self.value = sliderValue < 0.03 ? 0 : sliderValue
        
    }
    
    func transformColor(arc:UIColor) -> UIColor {
        let red = transformColorProperty(slider: arc, key:"red")
        let green = transformColorProperty(slider: arc, key:"green")
        let blue = transformColorProperty(slider: arc, key:"blue")
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func transformColorProperty(slider:UIColor, key:String) -> CGFloat {
        return CGFloat((slider.value(forKey: key) as! Float) * value)
    }
    
    func findArcLength(startPoint:CGPoint,endPoint:CGPoint, radius:CGFloat, thing: CGFloat) -> CGFloat{
        let c = sqrt(Square(value: startPoint.x - endPoint.x) + Square(value: startPoint.y - endPoint.y))
        let theta = acos(1 - (Square(value: c) / (2 * Square(value: radius))))
        
        return radius * theta

    }
    
    func drawArc(center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat, color:UIColor, shouldDrawShadow:Bool) -> CGPoint{
        
        let path = UIBezierPath(arcCenter:center, radius: radius/2.5 - lineWidth/2.5, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        if(shouldDrawShadow == true){
            let ctx = UIGraphicsGetCurrentContext()
//            CGContextSetShadowWithColor(ctx!, CGSize(width:2,height:2), 4, UIColor.black.cgColor)

        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
        
        
        return path.currentPoint
    }
    
    func moveSlider(point:CGPoint){
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let currentDegrees:CGFloat = AngleFromNorth(p1: center, p2: point, flipped: true)
        let maxDegrees = RadiansToDegrees(value: maxAngle)
        let minDegrees = RadiansToDegrees(value: startAngle)
        let currentRadians = DegreesToRadians(value: currentDegrees)
        
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
        self.baseColor = UIColor.black
        self.sliderColor = UIColor.blue
        self.value = 0.70
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.sliderAngle = CGFloat(3 * M_PI_2)
        self.startAngle = CGFloat(M_PI)
        self.maxAngle = CGFloat(M_PI) * 2
        self.lineWidth = CGFloat(10)
        self.baseColor = UIColor.black
        self.sliderColor = UIColor.blue
        self.value = 0.70
        
        super.init(coder: aDecoder)
        
    }
    
    func AngleFromNorth(p1:CGPoint , p2:CGPoint , flipped:Bool) -> CGFloat {
        var v: CGPoint = CGPoint(x: Double(p2.x - p1.x), y: Double(p2.y - p1.y))
        let vmag:CGFloat = Square(value: Square(value: v.x) + Square(value: v.y))
        var result:CGFloat = 0.0
        v.x /= vmag;
        v.y /= vmag;
        let radians = CGFloat(atan2(v.y,v.x))
        result = RadiansToDegrees(value: radians)
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
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let point = touch.location(in: self)
        self.moveSlider(point: point)
        self.sendActions(for: UIControlEvents.valueChanged)
        
        return true
    }
    

}
