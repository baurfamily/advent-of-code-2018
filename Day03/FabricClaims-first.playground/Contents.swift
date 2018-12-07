import Cocoa

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
        (fabric[point] = (fabric[point] ?? 0) + 1)
    }
}

var overlapCount = 0
for (_,value) in fabric {
    if value > 1 {
        (overlapCount += 1)
    }
}

print("total overlap: \(overlapCount)")
