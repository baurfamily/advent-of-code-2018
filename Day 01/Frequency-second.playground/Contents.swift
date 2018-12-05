import Cocoa

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)

let components = input.components(separatedBy: .newlines)

var freq = 0
var freqSet: Set = [ freq ]

loopy:
while true {
    for change in components {
        if let value = Int(change) {
            freq += value
            if freqSet.contains(freq) {
                print("found it! <\(freq)>")
                break loopy
            }
            freqSet.insert(freq)
        }
    }
}

print("Frequency: \(freq)")
