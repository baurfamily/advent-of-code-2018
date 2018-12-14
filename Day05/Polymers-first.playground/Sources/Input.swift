import Cocoa

public func getData(from: String) -> [String] {
    let dataUrl = Bundle.main.url(forResource: from, withExtension: "txt")
    let input = try! String(contentsOf: dataUrl!)
    let lines = input.components(separatedBy: .newlines)
    
    return lines
}
