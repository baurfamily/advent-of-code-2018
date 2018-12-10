import Cocoa

public class SleepEvent : CustomStringConvertible {
    public var start: Int?
    public var end: Int?

    public var length: Int? {
        if let s = start, let e = end {
            return e - s
        }
        return nil
    }
    
    init(start: Int) {
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
}

public enum RecordType {
    case beginShift, fallAsleep, wakeUp
}

public class DutyRecord {
    public var date: Date
    public var recordType: RecordType
    
    public var guardId: Int?
    
    static let dateRegex = try! NSRegularExpression(
        pattern: "^\\[(?<date>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2})\\]", options: [])
    static let guardRegex = try! NSRegularExpression(
        pattern: "Guard #(?<guardId>\\d+) begins shift$", options: [])
    static let sleepRegex = try! NSRegularExpression(
        pattern: "falls asleep$", options: [])
    static let awakeRegex = try! NSRegularExpression(
        pattern: "wakes up$", options: [])

    public var minute: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return Int(formatter.string(from: date))!
    }
    
    init?(fromString line: String) {
        let range = NSMakeRange(0, line.count)
        let matches = DutyRecord.dateRegex.matches(in: line, options: [], range: range)
        guard let match = matches.first else { return nil }

        let lineString = line as NSString

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let lineDate = formatter.date(from:lineString.substring(with: match.range(withName:"date"))) {
            self.date = lineDate
        } else {
            print("can't convert date: \(lineString.substring(with: match.range(withName:"date")))")
            return nil
        }
        
        if DutyRecord.guardRegex.numberOfMatches(in: line, options: [], range: range) > 0 {
            self.recordType = .beginShift
            let matches = DutyRecord.guardRegex.matches(in: line, options: [], range: range)
            if let match = matches.first {
                self.guardId = Int(lineString.substring(with: match.range(withName:"guardId")))!
            }
            
        } else if DutyRecord.sleepRegex.numberOfMatches(in: line, options: [], range: range) > 0 {
            self.recordType = .fallAsleep
            
        } else if DutyRecord.awakeRegex.numberOfMatches(in: line, options: [], range: range) > 0 {
            self.recordType = .wakeUp
        } else {
            return nil
        }
    }
}

public class Night : CustomStringConvertible {
    public var guardId: Int
    public var startTime: Date
    public var sleepEvents: [SleepEvent]
    
    private var dutyRecords: [DutyRecord]

    public var description: String {
        return "Guard ID: \(guardId) - asleep \(totalSleepTime)"
    }
    
    init?(startingRecord: DutyRecord) {
        guard startingRecord.recordType == .beginShift else { return nil }
        
        self.guardId = startingRecord.guardId!
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH"
//
//        let hour = formatter.string(from: startingRecord.date)
//
        
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

var tonight: Night? = nil
var nights: Array<Night> = []
var guards: Dictionary<Int,Array<Night>> = [:]
for line in getData(from:"sample").sorted() {
    print(line)
    if let dutyRecord = DutyRecord(fromString: line) {
        if dutyRecord.recordType == .beginShift {
            if let lastNight = tonight {
                print("record for last night: \(lastNight)" )
                print("total minutes asleep: \(lastNight.totalSleepTime)")
                print("night: \(lastNight)")
            }

            if let newNight = Night(startingRecord:dutyRecord) {
                tonight = newNight
                nights.append(newNight)
                if var guardRecords = guards[newNight.guardId] {
                    print("found new guard: \(newNight.guardId)")
                    guardRecords.append(newNight)
                    guards[newNight.guardId] = guardRecords
                } else {
                    print("appending to existing guard: \(newNight)")
                    guards[newNight.guardId] = [ newNight ]
                }
            }
            
        } else {
            tonight?.appendRecord(dutyRecord)
        }
    }
}

for (guardId, nights) in guards {
    print("Guard: \(guardId)")
    for night in nights {
        print("\t\(night)")
    }
    let total = nights.reduce(0, { total, night in
        total + night.totalSleepTime
    })
    print("total time asleep: \(total)")
}
