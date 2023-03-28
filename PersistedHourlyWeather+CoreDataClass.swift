import Foundation
import CoreData

@objc(PersistedHourlyWeather)
public class PersistedHourlyWeather: NSManagedObject {
    convenience init(hourlyWeather: HourlyWeatherModel, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "PersistedHourlyWeather", in: context) ?? NSEntityDescription()
        
        self.init(entity: entity, insertInto: context)
        
        self.id = Int64(hourlyWeather.id)
        self.hour = hourlyWeather.hour
        self.temperature = hourlyWeather.temperature
    }
}

extension PersistedHourlyWeather: Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedHourlyWeather> {
        return NSFetchRequest<PersistedHourlyWeather>(entityName: "PersistedHourlyWeather")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var hour: String
    @NSManaged public var temperature: Float
}
