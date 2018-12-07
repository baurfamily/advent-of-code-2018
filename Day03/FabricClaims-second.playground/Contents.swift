import Cocoa

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)
let lines = input.components(separatedBy: .newlines)

var claims: Dictionary<Int,Swatch> = [:]
var fabric: Dictionary<Point,Set<Swatch>> = [:]

for line in lines {
    guard line.count > 0 else { continue }

    let swatch = Swatch.parse(line)
    claims[swatch.id] = swatch
    
    for point in swatch.points {
        if var set = fabric[point] {
            (set.insert(swatch))
            (fabric[point] = set)
        } else {
            (fabric[point] = [swatch])
        }
    }
}

for (_,set) in fabric {
    if (set.count > 1) {
        for var swatch in set {
            swatch.overlapped = true
        }
    }
}

for (_,swatch) in claims {
    if swatch.overlapped == false {
        print("found non-overlapped swatch: \(swatch.description)")
    }
}
