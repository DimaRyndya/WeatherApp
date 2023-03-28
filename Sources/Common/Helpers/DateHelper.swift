import Foundation

final class DateHelper {
    
    // MARK: - Properties
    
    private static var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    // MARK: - Static public methods
    
    static func getDay(from dateString: String) -> String {
        let now = Date()
        
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dayFormatter.date(from: dateString) else { return "" }
        
        if Calendar.current.isDate(date, equalTo: now, toGranularity: .day) {
            return "Today"
        }
        
        dayFormatter.dateFormat = "EEEE"
        
        return dayFormatter.string(from: date)
    }
    
    static func getTime(from dateString: String) -> String {
        let now = Date()
        
        dayFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = dayFormatter.date(from: dateString) else { return "" }
        
        if Calendar.current.isDate(date, equalTo: now, toGranularity: .hour) {
            return "Now"
        }
        
        dayFormatter.dateFormat = "HH"
        
        return dayFormatter.string(from: date)
    }
}
