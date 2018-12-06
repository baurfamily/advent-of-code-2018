import Cocoa

let dataUrl = Bundle.main.url(forResource: "data", withExtension: "txt")
let input = try! String(contentsOf: dataUrl!)

let lines = input.components(separatedBy: .newlines)

func returnIfMatch(ids: [String], atIndex: Int) -> String? {
    var testing: Set<String> = []
    for id in ids {
        guard id.count >= atIndex else { continue }
        var testId = id

        let stringIndex = testId.index(testId.startIndex, offsetBy: atIndex)
        testId.remove(at: stringIndex)

        if testing.contains(testId) {
            return testId
        }
        testing.insert(testId)
    }
    return nil
}

for i in stride(from: 0, to: lines[0].count-1, by: 1) {
    if let match = returnIfMatch(ids: lines, atIndex: i) {
        print("found a match! <\(match)>")
    }
}
