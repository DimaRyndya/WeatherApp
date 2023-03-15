import Foundation
import CoreData

@objc(PersistedDailyWeather)
public class PersistedDailyWeather: NSManagedObject {
    convenience init(dailyWeather: DailyWeatherModel) {
        self.init()
        self.day =  dailyWeather.day
        self.minTemp = dailyWeather.minTemp
        self.maxTemp = dailyWeather.maxTemp
    }
}

extension PersistedDailyWeather: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedDailyWeather> {
        return NSFetchRequest<PersistedDailyWeather>(entityName: "PersistedDailyWeather")
    }

    @NSManaged public var day: String
    @NSManaged public var minTemp: Float
    @NSManaged public var maxTemp: Float
    
}
