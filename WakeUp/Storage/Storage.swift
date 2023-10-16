import Foundation

final class RecordsStorage {
    
    static let shared = RecordsStorage()
    
    //MARK: - Private properties
    private var storage = UserDefaults.standard
    private var recordsKey = "records"
    
    private var recordsFromStorage: [Date] = []
    
    // MARK: - Public Methods
    func loadRecords() {
        recordsFromStorage = storage.array(forKey: recordsKey) as? [Date] ?? []
    }
    
    func saveRecord(date: Date) {
        var recordsForStorage = recordsFromStorage
        recordsForStorage.append(date)
                
        storage.set(recordsForStorage, forKey: recordsKey)
        loadRecords()
    }
    
    func deleteRecord(time: Date) {
        var recordsForStorage = recordsFromStorage
        
        guard let indexOfDeleted = recordsForStorage.firstIndex(of: time) else { return }
        recordsForStorage.remove(at: indexOfDeleted)
       
        storage.set(recordsForStorage, forKey: recordsKey)
        loadRecords()
    }
    
    func clearStorage() {
        storage.set(nil, forKey: recordsKey)
    }
    
    func getDates() -> [Date] {
        
        let datesSet = Set(recordsFromStorage.map { $0.withoutTime() } )
        let datesSorted = Array(datesSet).sorted { $0 > $1 }
        return datesSorted
    }
    
    func getDateString() -> [String] {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        
        let dates = getDates()
        var dateStrings: [String] = []
        dates.forEach { date in
            dateStrings.append(df.string(from: date))
        }
        return dateStrings
    }
    
    func getTimes(for date: Date) -> [Date] {
        let timesForDate = recordsFromStorage.filter {
            $0.withoutTime() == date.withoutTime()
        }
        return timesForDate
    }
    
    func getTimeStrings(for date: Date) -> [String] {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
        let times = getTimes(for: date)
        var timeStrings: [String] = []
        times.forEach { time in
            timeStrings.append(df.string(from: time))
        }
        return timeStrings
    }
}
