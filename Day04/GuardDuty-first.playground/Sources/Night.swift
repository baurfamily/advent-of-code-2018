import Foundation
import Cocoa

public class Night : CustomStringConvertible {
    public var guardId: Int
    public var startTime: Date
    public var sleepEvents: [SleepEvent]
    
    private var dutyRecords: [DutyRecord]
    
    public var description: String {
        return "Guard ID: \(guardId) - asleep \(totalSleepTime)"
    }
    
    public init?(startingRecord: DutyRecord) {
        guard startingRecord.recordType == .beginShift else { return nil }
        
        self.guardId = startingRecord.guardId!
        self.startTime = startingRecord.date
        self.dutyRecords = [ startingRecord ]
        self.sleepEvents = []
    }
    
    public func appendRecord(_ record: DutyRecord) {
        switch(record.recordType) {
        case .fallAsleep:
            let event = SleepEvent(start: record.minute)
            sleepEvents.append(event)
        case .wakeUp:
            if let event = sleepEvents.last {
                event.end = record.minute
            }
        default: break
        }
        dutyRecords.append(record)
    }
    
    public var totalSleepTime: Int {
        return sleepEvents.reduce(0, { total, event in
            total + (event.length ?? 0)
        })
    }
    
    public var sleepArray: Array<Int> {
        return sleepEvents.reduce( Array(repeating: 0, count: 60), { returnArray, event in
            if let start = event.start, let end = event.end {
                var tempArray = returnArray
                for min in stride(from: start, through: (end-1), by: 1) {
                    tempArray[min] = tempArray[min] + 1
                }
                return tempArray
            }
            return returnArray
        })
    }
}
