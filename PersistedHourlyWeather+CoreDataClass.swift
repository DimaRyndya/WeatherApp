import Foundation
import CoreData

@objc(PersistedHourlyWeather)
public class PersistedHourlyWeather: NSManagedObject {

}

extension PersistedHourlyWeather: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedHourlyWeather> {
        return NSFetchRequest<PersistedHourlyWeather>(entityName: "PersistedHourlyWeather")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var temperature: Float

}
