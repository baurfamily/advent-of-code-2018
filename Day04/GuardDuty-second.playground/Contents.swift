import Cocoa

var tonight: Night? = nil
var nights: Array<Night> = []
var guards: Dictionary<Int,Guard> = [:]
for line in getData(from:"data").sorted() {
    if let dutyRecord = DutyRecord(fromString: line) {
        if dutyRecord.recordType == .beginShift {
            if let newNight = Night(startingRecord:dutyRecord) {
                tonight = newNight
                nights.append(newNight)
                if let guardRecord = guards[newNight.guardId] {
                    guardRecord.nights.append(newNight)
                    guards[newNight.guardId] = guardRecord
                } else {
                    guards[newNight.guardId] = Guard(id:newNight.guardId)
                }
            }
            
        } else {
            tonight?.appendRecord(dutyRecord)
        }
    }
}

var sleepiestGuard: Guard = guards.first!.value
var sleepiestMinute = 0
var maxSleep = 0

for (_, guardRecord) in guards {
    let guardSleep = guardRecord.maxSleep
    if guardSleep > maxSleep {
        maxSleep = guardSleep
        sleepiestGuard = guardRecord
    }
}

print("Guard #\(sleepiestGuard.id) slept for \(maxSleep) minutes")
print("\tthe guard sleep the most at minute: \(sleepiestGuard.sleepistMinute)")

print("solution: \(sleepiestGuard.id * sleepiestGuard.sleepistMinute)")
