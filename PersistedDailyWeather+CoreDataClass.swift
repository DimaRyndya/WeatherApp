import UIKit
import CoreData

@objc(PersistedDailyWeather)
public class PersistedDailyWeather: NSManagedObject {
    convenience init(dailyWeather: DailyWeatherModel, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "PersistedDailyWeather", in: context) ?? NSEntityDescription()
        
        self.init(entity: entity, insertInto: context)
        
        self.id = Int64(dailyWeather.id)
        self.day =  dailyWeather.day
        self.minTemp = dailyWeather.minTemp
        self.maxTemp = dailyWeather.maxTemp
    }
}

extension PersistedDailyWeather: Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedDailyWeather> {
        return NSFetchRequest<PersistedDailyWeather>(entityName: "PersistedDailyWeather")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var day: String
    @NSManaged public var minTemp: Float
    @NSManaged public var maxTemp: Float
    @NSManaged public var weatherImage: Data
}
