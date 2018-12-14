import Cocoa

//I don't think this does quite what I want it to
guard let polymer = getData(from: "data").first else { exit(0) }

var smallestLetter = "A"
var smallestPolymerCount = polymer.count
for letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
    let editedPolymer = polymer.replacingOccurrences(of: String(letter), with: "").replacingOccurrences(of: String(letter).lowercased(), with: "")
    let editedCount = resolvePolarity(polymer: editedPolymer).count
    print("letter \(letter): \(editedPolymer.count) -> \(editedCount)")

    if editedCount < smallestPolymerCount {
        smallestPolymerCount = editedCount
        smallestLetter = String(letter)
    }
}

print("letter: \(smallestLetter)")
print("edited: \(smallestPolymerCount)")
