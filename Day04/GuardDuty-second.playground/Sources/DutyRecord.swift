import Foundation
import Cocoa

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
    
    public init?(fromString line: String) {
        let range = NSMakeRange(0, line.count)
        let matches = DutyRecord.dateRegex.matches(in: line, options: [], range: range)
        guard let match = matches.first else { return nil }
        
        let lineString = line as NSString
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let lineDate = formatter.date(from:lineString.substring(with: match.range(withName:"date"))) {
            self.date = lineDate
        } else {
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
