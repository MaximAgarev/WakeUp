import Foundation

final class RecordsStorage {
    
    static let shared = RecordsStorage()
    
    //MARK: - Private properties
    private var storage = UserDefaults.standard
    private var recordsKey = "records"
    
    private var records: [(String, String)] = []
    
    private enum RecordKey: String {
        case date
        case time
    }
    
    // MARK: - Public Methods
    func loadRecords() -> [(String, String)] {
        var result: [(String, String)] = []
        let recordsFromStorage = storage.array(forKey: recordsKey) as? [[String: String]]
        guard let recordsFromStorage = recordsFromStorage else { return [] }
        
        for record in recordsFromStorage {
            guard let date = record[RecordKey.date.rawValue] else { continue }
            guard let time = record[RecordKey.time.rawValue] else {continue }
            result.append((date, time))
        }
        
        records = result
        return result
    }
    
    func saveRecord(date: String, time: String) {
        let currentRecord = (date, time)
        if records.contains(where: { currentRecord == $0 }) { return }
            
        records.append(currentRecord)
        
        var recordsForStorage: [[String: String]] = []
        records.forEach { record in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[RecordKey.date.rawValue] = record.0
            newElementForStorage[RecordKey.time.rawValue] = record.1
            recordsForStorage.append(newElementForStorage)
        }
        
        storage.set(recordsForStorage, forKey: recordsKey)
    }
}
