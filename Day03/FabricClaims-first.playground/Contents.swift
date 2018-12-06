import Cocoa

//we assume no more than 10,000 points in a row
struct Point: Hashable {
    let x: Int
    let y: Int
    
    var hashValue: Int {
        return 10000*x + y
    }
}
func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

struct Swatch {
    var id: Int
    
    var xPos: Int
    var yPos: Int
    
    var width: Int
    var height: Int
    
    static func parse(_ description: String) -> Swatch {
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
    
    var points: [Point] {
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

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)
let lines = input.components(separatedBy: .newlines)

var claims: Dictionary<Int,Swatch> = [:]
var fabric: Dictionary<Point,Int> = [:]

for line in lines {
    guard line.count > 0 else { continue }

    let swatch = Swatch.parse(line)
    claims[swatch.id] = swatch
    
    for point in swatch.points {
        fabric[point] = (fabric[point] ?? 0) + 1
    }
}

var overlapCount = 0
for (key,value) in fabric {
    if value > 1 {
        overlapCount += 1
        print("Overlap of \(value) at: \(key)")
    }
}

print("total overlap: \(overlapCount)")
