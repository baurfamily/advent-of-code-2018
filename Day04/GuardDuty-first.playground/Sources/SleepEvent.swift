import Cocoa
import Foundation

public class SleepEvent : CustomStringConvertible {
    public var start: Int?
    public var end: Int?
    
    public var length: Int? {
        if let s = start, let e = end {
            return e - s
        }
        return nil
    }
    
    public init(start: Int) {
        self.start = start
    }
    
    public var description: String {
        if let s = start {
            if let e = end {
                return "SleepEvent: \(s)-\(e)"
            } else {
                return "SleepEvent: \(s)-<na>"
            }
        } else {
            return "SleepEvent: ??-na"
        }
    }
    
    public var sleepRange: Array<Int> {
        var returnArray = Array(repeating: 0, count: 60)
        if let s = start, let e = end {
            for min in stride(from: s, through: (e-1), by: 1) {
                returnArray[min] = 1
            }
        }
        return returnArray
    }
}

