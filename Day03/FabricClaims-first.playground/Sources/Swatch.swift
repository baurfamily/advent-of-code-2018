import Cocoa

//we assume no more than 10,000 points in a row
public struct Point: Hashable {
    public let x: Int
    public let y: Int
    
    public var hashValue: Int {
        return 10000*x + y
    }
}
public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public struct Swatch {
    public var id: Int
    
    public var xPos: Int
    public var yPos: Int
    
    public var width: Int
    public var height: Int
    
    public static func parse(_ description: String) -> Swatch {
        //ugh, gets around range issues with substring/match
        let desc = description as NSString
        
        let regex = try! NSRegularExpression(pattern: "^#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)$", options: [])
        
        let matches = regex.matches(in: description, options: [], range: NSMakeRange(0, description.count))
        let match = matches.first!
        
        
        return Swatch(
            id: Int(desc.substring(with: match.range(at: 1)))!,
            xPos: Int(desc.substring(with: match.range(at: 2)))!,
            yPos: Int(desc.substring(with: match.range(at: 3)))!,
            width: Int(desc.substring(with: match.range(at: 4)))!,
            height: Int(desc.substring(with: match.range(at: 5)))!
        )
    }
    
    public var points: [Point] {
        get {
            var p: Array<Point> = []
            
            for i in stride(from: xPos, to: xPos+width, by: 1) {
                for j in stride(from: yPos, to: yPos+height, by: 1) {
                    p.append(Point(x: i, y: j))
                }
            }
            return p
        }
    }
}
