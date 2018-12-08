import Cocoa

public struct SleepEvent {
    public var start: Int
    public var end: Int

    public var length: Int {
        return end - start
    }
}

public enum RecordType {
    case beginShift, fallAsleep, wakeUp
}

public class DutyRecord {
    public var date: Date
    public var recordType: RecordType
    
    public var guardId: Int?
    
    static let dateRegex = try! NSRegularExpression(pattern: "^\\[(?<date>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2})\\]", options: [])
    static let guardRegex = try! NSRegularExpression(pattern: "Guard #(?<guardId>\\d+) begins shift$", options: [])
    static let sleepRegex = try! NSRegularExpression(pattern: "falls asleep$", options: [])
    static let awakeRegex = try! NSRegularExpression(pattern: "wakes up$", options: [])

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

public class Night {
    public var guardId: Int
    public var startTime: Date
    public var sleepEvents: [SleepEvent]
    
    private var dutyRecords: [DutyRecord]

    init?(startingRecord: DutyRecord) {
        guard startingRecord.recordType == .beginShift else { return nil }
        
        self.guardId = startingRecord.guardId!
        self.startTime = startingRecord.date

        self.dutyRecords = [ startingRecord ]
        self.sleepEvents = []
    }

    public func appendRecord(_ record: DutyRecord) {
        dutyRecords.append(record)
    }
    
    public var totalSleepTime: Int {
        return sleepEvents.reduce(0, { total, event in
            total + event.length
        })
    }
}

var tonight: Night? = nil
var nights: Array<Night> = []
for line in getData(from:"sample") {
    print(line)
    if let dutyRecord = DutyRecord(fromString: line) {
        if dutyRecord.recordType == .beginShift {
            if let lastNight = tonight {
                print("record for last night: \(lastNight)" )
            }

            tonight = Night(startingRecord:dutyRecord)
            nights.append(tonight!)
            
        } else {
            tonight?.appendRecord(dutyRecord)
        }
    }
}