import Cocoa

struct Swatch {
    var id: Int
    
    var xPos: Int
    var yPos: Int
    
    var width: Int
    var height: Int
    
    static func parse(_ description: String) -> Swatch {
        //ugh, gets around range issues with substring/match
        let desc = description as NSString

        let regex = try! NSRegularExpression(pattern: "^#(\\d) @ (\\d+),(\\d+): (\\d+)x(\\d+)$", options: [])
        
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
}

let dataUrl = Bundle.main.url(forResource: "sample", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)

let lines = input.components(separatedBy: .newlines)

var claims: Dictionary<Int,Swatch> = [:]
for line in lines {
    guard line.count > 0 else { continue }
    print("converting line: <\(line)>")
    let swatch = Swatch.parse(line)
    claims[swatch.id] = swatch
}

print(claims)
