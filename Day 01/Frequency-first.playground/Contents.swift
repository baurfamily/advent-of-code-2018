import Cocoa

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)

//let components = input.split(separator: "\n")

let components = input.components(separatedBy: .newlines)

var freq = 0

for change in components {
    print("looking at <\(change)>")
    
    if let value = Int(change) {
        freq += value
    }
}

print("Frequency: \(freq)")
