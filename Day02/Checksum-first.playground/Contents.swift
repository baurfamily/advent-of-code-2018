import Cocoa

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)

let lines = input.components(separatedBy: .newlines)

func scoreOf(id: String) -> (two: Bool, three: Bool) {
    var chars: Dictionary<Character,Int> = [:]
    
    for ch in id {
        chars[ch] = (chars[ch] ?? 0) + 1
    }
    
    var foundTwo = false
    var foundThree = false
    
    for (_, cnt) in chars {
        if cnt==2 {
            foundTwo = true
        } else if cnt==3 {
            foundThree = true
        }
    }
    
    return (foundTwo, foundThree)
}

var twosFound = 0
var threesFound = 0

for boxId in lines {
    let score = scoreOf(id:boxId)
    if score.two { twosFound += 1 }
    if score.three { threesFound += 1 }
}

//final score
print("Checksum: \(twosFound * threesFound)")

