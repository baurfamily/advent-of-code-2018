import Cocoa

var tonight: Night? = nil
var nights: Array<Night> = []
var guards: Dictionary<Int,Array<Night>> = [:]
for line in getData(from:"data").sorted() {
    if let dutyRecord = DutyRecord(fromString: line) {
        if dutyRecord.recordType == .beginShift {
            if let newNight = Night(startingRecord:dutyRecord) {
                tonight = newNight
                nights.append(newNight)
                if var guardRecords = guards[newNight.guardId] {
                    guardRecords.append(newNight)
                    guards[newNight.guardId] = guardRecords
                } else {
                    guards[newNight.guardId] = [ newNight ]
                }
            }
            
        } else {
            tonight?.appendRecord(dutyRecord)
        }
    }
}

var sleepiestGuardId = 0
var maxSleep = 0
for (guardId, nights) in guards {
    let total = nights.reduce(0, { total, night in
        total + night.totalSleepTime
    })
    if total > maxSleep {
        maxSleep = total
        sleepiestGuardId = guardId
    }
}

print("Guard #\(sleepiestGuardId) slept for \(maxSleep) minutes")

var sleepArray = Array(repeating: 0, count: 60)

let tens = (0...59).map{ $0 / 10 }
let ones = (0...59).map{ $0 % 10 }

print(tens.map{String($0)}.joined())
print(ones.map{String($0)}.joined())

if let nights = guards[sleepiestGuardId] {
    sleep
}

print(sleepArray.map{String($0)}.joined())
let max = sleepArray.max()
let position = sleepArray.firstIndex(of: max!)
print("\tthe guard sleep the most at minute: \(position!)")

print("solution: \(sleepiestGuardId * position!)")
