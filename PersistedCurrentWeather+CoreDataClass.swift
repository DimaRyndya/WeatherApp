import Foundation
import CoreData

@objc(PersistedCurrentWeather)
public class PersistedCurrentWeather: NSManagedObject {

}

extension PersistedCurrentWeather: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedCurrentWeather> {
        return NSFetchRequest<PersistedCurrentWeather>(entityName: "PersistedCurrentWeather")
    }

    @NSManaged public var city: String
    @NSManaged public var temperature: Float
    @NSManaged public var summary: String
}
