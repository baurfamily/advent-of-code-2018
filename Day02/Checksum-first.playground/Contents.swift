import Cocoa

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)

let lines = input.components(separatedBy: .newlines)

func scoreOf(id: String) -> Int {
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
    
    return (foundTwo ? 1 : 0) + (foundThree ? 1 : 0)
}

scoreOf(id:"ababab")
//for boxId in lines {
//    print("Box \(boxId) => \(scoreOf(id:boxId))")
//}

