import Foundation
import CoreData

final class CacheService {

    // MARK: - Properties

    private let currentWeatherFetchRequest = NSFetchRequest<PersistedCurrentWeather>(entityName: "PersistedCurrentWeather")
    private let dailyWeatherFetchRequest = NSFetchRequest<PersistedDailyWeather>(entityName: "PersistedDailyWeather")
    private let hourlyWeatherFetchRequest = NSFetchRequest<PersistedHourlyWeather>(entityName: "PersistedHourlyWeather")

    private lazy var managedObjectContext = persistentContainer.viewContext
    private lazy var persistedHourlyWeather = PersistedHourlyWeather(context: managedObjectContext)

    // MARK: - Public

    func save(currentWeather: CurrentWeatherModel) {
        guard let fetchedWeather = try? managedObjectContext.fetch(currentWeatherFetchRequest) else { return }

        if fetchedWeather.isEmpty {
            let persistedCurrentWeather = PersistedCurrentWeather(context: managedObjectContext)

            persistedCurrentWeather.city = currentWeather.city
            persistedCurrentWeather.temperature = currentWeather.temperature
            persistedCurrentWeather.summary = currentWeather.summary
        } else {
            if let persistedCurrentWeather = fetchedWeather.first {
                persistedCurrentWeather.city = currentWeather.city
                persistedCurrentWeather.temperature = currentWeather.temperature
                persistedCurrentWeather.summary = currentWeather.summary
            }
        }

        saveContext()
    }

    func save(dailyWeather: [DailyWeatherModel]) {
        guard var fetchedDailyWeather = try? managedObjectContext.fetch(dailyWeatherFetchRequest) else { return }

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PersistedDailyWeather")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        if fetchedDailyWeather.isEmpty {
            fetchedDailyWeather = dailyWeather.map { PersistedDailyWeather(dailyWeather: $0, context: managedObjectContext) }
        } else {
            do {
                try managedObjectContext.execute(deleteRequest)
            } catch {
                print("Error deleting objects: \(error.localizedDescription)")
            }
            fetchedDailyWeather = dailyWeather.map { PersistedDailyWeather(dailyWeather: $0, context: managedObjectContext) }
        }

        saveContext()
    }

    func save(hourlyWeather: [HourlyWeatherModel]) {
        guard var fetchedWeather = try? managedObjectContext.fetch(hourlyWeatherFetchRequest) else { return }

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PersistedHourlyWeather")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        if fetchedWeather.isEmpty {
            fetchedWeather = hourlyWeather.map { PersistedHourlyWeather(hourlyWeather: $0, context: managedObjectContext) }
        } else {
            do {
                try managedObjectContext.execute(deleteRequest)
            } catch {
                print("Error deleting objects: \(error.localizedDescription)")
            }
            fetchedWeather = hourlyWeather.map { PersistedHourlyWeather(hourlyWeather: $0, context: managedObjectContext) }
        }

        saveContext()
    }


    func fetchCurrentWeather() -> CurrentWeatherModel {
        guard let fetchedWeather = try? managedObjectContext.fetch(currentWeatherFetchRequest).first else { return CurrentWeatherModel() }

        var currentWeather = CurrentWeatherModel()

        currentWeather.city = fetchedWeather.city
        currentWeather.temperature = fetchedWeather.temperature
        currentWeather.summary = fetchedWeather.summary

        return currentWeather
    }

    func fetchDailyWeather() -> [DailyWeatherModel] {
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)

        dailyWeatherFetchRequest.sortDescriptors = [sortDescriptor]

        guard let fetchedDailyWaether = try? managedObjectContext.fetch(dailyWeatherFetchRequest) else { return [] }

        var dailyWeather: [DailyWeatherModel] = []

        dailyWeather = fetchedDailyWaether.map { DailyWeatherModel(persistedDailyWeather: $0) }

        return dailyWeather
    }

    func fetchHourlyWeather() -> [HourlyWeatherModel] {
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)

        hourlyWeatherFetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let fetchedDailyWaether = try? managedObjectContext.fetch(hourlyWeatherFetchRequest) else { return [] }

        var hourlyWeather: [HourlyWeatherModel] = []

        hourlyWeather = fetchedDailyWaether.map { HourlyWeatherModel(persistedHourlyWeather: $0) }

        return hourlyWeather
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
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
