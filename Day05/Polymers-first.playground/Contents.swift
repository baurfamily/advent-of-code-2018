import Cocoa

//I don't think this does quite what I want it to
guard let polymer = getData(from: "data").first else { exit(0) }

let editedPolymer = resolvePolarity(polymer: polymer)

print("length: \(polymer.count)")
print("edited: \(editedPolymer.count)")
