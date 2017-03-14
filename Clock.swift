import Cocoa

class Clock: NSView{
    
    var textRadiusMultiplier = 0.8
    var radius = 100.0
    var secondhandColor: NSColor = NSColor.red
    var minutehandColor: NSColor = NSColor.black
    var hourhandColor: NSColor = NSColor.green
    var backgroundColor: NSColor = NSColor.white
    var borderColor: NSColor = NSColor.darkGray
    var centreColor: NSColor = NSColor.red
    var showNumbers = true
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        drawBorder()
        drawTicks()
        let date = Date()
        drawMinuteHand(date: date)
        drawHourHand(date: date)
        drawSecondHand(date: date)
        drawCentre()
        if showNumbers {
            drawNumbers()
        }
        
    }
    
    func drawBorder(){
        borderColor.setStroke()
        let face = NSBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        face.stroke()
        backgroundColor.setFill()
        face.fill()
    }
    
    func drawTicks(){
        NSColor.black.set()
        for i in 1...60{
            let angle = Double(i) * 6.0 * Double.pi / 180
            let path = NSBezierPath()
            path.move(to: CGPoint(x: radius + cos(angle) * radius, y: radius + sin(angle) * radius))
            if(i%5==0){
                NSColor.black.setStroke()
                path.line(to: CGPoint(x: radius + cos(angle) * 90, y: radius + sin(angle) * 90))
            }else{
                NSColor.lightGray.setStroke()
                path.line(to: CGPoint(x: radius + cos(angle) * 95, y: radius + sin(angle) * 95))
            }
            path.stroke()
        }
    }
    
    func drawNumbers(){
        let txtRadius = radius * textRadiusMultiplier
        NSColor.black.set()
        for i in 1...12{
            let number = NSAttributedString(string: String(i), attributes:[
                NSForegroundColorAttributeName: NSColor.black])
            let angle = (-(Double(i) * 30.0) + 90) * Double.pi / 180
            let numberRect =  CGRect(
                x:CGFloat(radius + cos(angle) * txtRadius - Double(number.size().width/2)),
                y:CGFloat(radius + sin(angle) * txtRadius - Double(number.size().height/2)),
                width:number.size().width,
                height:number.size().height)
            number.draw(in:numberRect)
        }
    }
    
    func drawCentre(){
        centreColor.setFill()
        let centre = NSBezierPath(ovalIn: CGRect(x: 95, y: 95, width: 10, height: 10))
        centre.fill()
    }
    
    func drawMinuteHand(date: Date){
        let cal = Calendar.current
        let minute = cal.component(.minute, from: Date())
        
        let angle =  -Double(minute) * 360.0 / 60.0 + 90
        let radians = angle * Double.pi / 180
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: radius, y: radius ))
        path.line(to: CGPoint(x: radius + cos(radians) * 90, y: radius + sin(radians) * 90))
        path.stroke()
    }
    
    func drawHourHand(date: Date){
        let cal = Calendar.current
        let hour = cal.component(.hour, from: date)
        let angle = -Double(hour%12) * 360.0 / 12 + 90
        let radians = angle * Double.pi / 180
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: radius, y: radius ))
        path.line(to: CGPoint(x: radius + cos(radians) * 70, y: radius + sin(radians) * 70))
        path.lineWidth = CGFloat(3)
        path.stroke()
    }
    
    func drawSecondHand(date: Date){
        let cal = Calendar.current
        let second = cal.component(.second, from: date)
        let angle = -Double(second) * 360.0 / 60 + 90
        let radians = angle * Double.pi / 180
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: radius, y: radius ))
        path.line(to: CGPoint(x: radius + cos(radians) * 90, y: radius + sin(radians) * 90))
        path.lineWidth = CGFloat(1)
        NSColor.red.setStroke()
        path.stroke()
    }
    
    func tick(){
        self.needsDisplay = true
    }
    
    func startTimer(){
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
}
