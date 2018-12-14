import Foundation

public func resolvePolarity(polymer: String) -> String {
    var editedPolymer = polymer
    
    let end = editedPolymer.count
    var i = end-1
    while i > 0 {
        guard i < editedPolymer.count else { i -= 1; continue }

        let index0 = editedPolymer.index(editedPolymer.startIndex, offsetBy: i)
        let index1 = editedPolymer.index(editedPolymer.startIndex, offsetBy: i-1)        
        
        let char0 = String(editedPolymer[index0])
        let char1 = String(editedPolymer[index1])
        
        guard char0.lowercased() == char1.lowercased() else { i -= 1; continue }
        guard char0 != char1 else { i -= 1; continue }
        
        editedPolymer.remove(at: index0)
        editedPolymer.remove(at: index1)
        
        i -= 1
    }
    
    return editedPolymer
}
