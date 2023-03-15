import Foundation
import CoreData

final class CacheService {

    private lazy var managedObjectContext = persistentContainer.viewContext

    private let currentWeatherFetchRequest = NSFetchRequest<PersistedCurrentWeather>(entityName: "PersistedCurrentWeather")
    private let dailyWeatherFetchRequest = NSFetchRequest<PersistedDailyWeather>(entityName: "PersistedDailyWeather")
    private let hourlyWeatherFetchRequest = NSFetchRequest<PersistedHourlyWeather>(entityName: "PersistedHourlyWeather")
    
    private lazy var persistedCurrentWeather = PersistedCurrentWeather(context: managedObjectContext)
    private lazy var persistedDailyWeather = PersistedDailyWeather(context: managedObjectContext)
    private lazy var persistedHourlyWeather = PersistedHourlyWeather(context: managedObjectContext)

    func save(dailyWeather: [DailyWeatherModel]) {
        guard var fetchedWeather = try? managedObjectContext.fetch(dailyWeatherFetchRequest) else { return }
        if fetchedWeather.isEmpty {
            fetchedWeather = dailyWeather.map { PersistedDailyWeather(dailyWeather: $0) }
        }

        do {
            try managedObjectContext.save()
        } catch {
            assertionFailure("Error: \(error)")
        }
    }

    func save(currentWeather: CurrentWeatherModel) {

        guard let fetchedWeather = try? managedObjectContext.fetch(currentWeatherFetchRequest) else { return }
        if fetchedWeather.isEmpty {
            persistedCurrentWeather.city = currentWeather.city
            persistedCurrentWeather.temperature = currentWeather.temperature
            persistedCurrentWeather.summary = currentWeather.summary
        }

        if let persistedWeather = fetchedWeather.first {
            persistedWeather.city = currentWeather.city
            persistedWeather.temperature = currentWeather.temperature
            persistedWeather.summary = currentWeather.summary
        }

        do {
            try managedObjectContext.save()
        } catch {
            assertionFailure("Error: \(error)")
        }
    }

    func fetchCurrentWeather() -> CurrentWeatherModel? {
        guard let fetchedWeather = try? managedObjectContext.fetch(currentWeatherFetchRequest).first else { return nil }
        persistedCurrentWeather = fetchedWeather
        var currentWeather = CurrentWeatherModel()
        currentWeather.city = persistedCurrentWeather.city
        currentWeather.temperature = persistedCurrentWeather.temperature
        currentWeather.summary = persistedCurrentWeather.summary

        return currentWeather
    }

    func fetchDailyWeather() -> [DailyWeatherModel]? {
        guard let fetchedDailyWaether = try? managedObjectContext.fetch(dailyWeatherFetchRequest) else { return nil }
        var dailyWeather: [DailyWeatherModel] = []
        dailyWeather = fetchedDailyWaether.map { DailyWeatherModel(persistedDailyWeather: $0) }

        return dailyWeather
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
