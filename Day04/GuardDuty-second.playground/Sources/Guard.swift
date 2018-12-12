import Foundation
import Cocoa

public class Guard {
    public let id: Int
    public var nights: Array<Night> = []
    
    public init(id: Int) {
        self.id = id
    }
    
    public var sleepTime: Int {
        return nights.reduce(0, { total, night in
            total + night.totalSleepTime
        })
    }
    
    public var maxSleep: Int {
        var maxSleep = 0
        for minutesAsleep in sleepArray {
            if minutesAsleep > maxSleep {
                maxSleep = minutesAsleep
            }
        }
        return maxSleep
    }
    
    public var sleepistMinute: Int {
        return sleepArray.firstIndex(of: maxSleep)!
    }
    
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
