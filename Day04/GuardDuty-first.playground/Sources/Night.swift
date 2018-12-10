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
            print("adding sleep event: \(event)")
            sleepEvents.append(event)
        case .wakeUp:
            if let event = sleepEvents.last {
                event.end = record.minute
                print("ending sleep event: \(event)")
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
}
