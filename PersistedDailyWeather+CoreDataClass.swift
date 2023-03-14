import Foundation
import CoreData

@objc(PersistedDailyWeather)
public class PersistedDailyWeather: NSManagedObject {

}

extension PersistedDailyWeather: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedDailyWeather> {
        return NSFetchRequest<PersistedDailyWeather>(entityName: "PersistedDailyWeather")
    }

    @NSManaged public var day: String
    @NSManaged public var minTemp: Float
    @NSManaged public var maxTemp: Float
    
}
