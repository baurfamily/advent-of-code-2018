import Cocoa

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
