import Foundation

extension Date {
    func withoutSeconds() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let date = Calendar.current.date(from: components) else { return Date() }
        return date
    }
    
    func withoutTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: components) else { return Date() }
        return date
    }
}
