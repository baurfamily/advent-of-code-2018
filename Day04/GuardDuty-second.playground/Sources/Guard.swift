import Foundation
import Cocoa

public class Guard {
    public var nights: Array<Night> = []
    
    public var sleepArray: Array<Int> {
        var sleep: Array<Int> = Array(repeating: 0, count: 60)
        for night in nights {
            // print(night.sleepArray.map({ $0 == 0 ? "." : "#" }).joined())
            for (min, val) in night.sleepArray.enumerated() {
                sleep[min] = sleep[min] + val
            }
        }
        return sleep
    }
}
