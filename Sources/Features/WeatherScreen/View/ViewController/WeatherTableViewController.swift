import UIKit

final class WeatherTableViewController: UITableViewController {

    //MARK: Properties

    var viewModel: WeatherViewModel!
    private var tableHeaderView: WeatherHeaderView?

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: DailyWeatherTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        nib = UINib(nibName: HourlyWeatherTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        nib = UINib(nibName: WeatherHeaderView.nibName, bundle: nil)
        tableHeaderView = nib.instantiate(withOwner: self, options: nil).first as? WeatherHeaderView

        tableHeaderView?.configure(with: viewModel.currentWeather)
        tableView.tableHeaderView = tableHeaderView

        viewModel.getWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startMonitoring()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return viewModel.dailyWeather.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier) as! HourlyWeatherTableViewCell

            cell.configure(with: viewModel.hourlyWeather)
            cell.selectionStyle = .none

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier) as! DailyWeatherTableViewCell
        let weather = viewModel.dailyWeather[indexPath.row]

        cell.configure(with: weather)
        cell.selectionStyle = .none

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 120
        }
        return 60
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Hourly Weather"
        }
        return "10-days Forecast"
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }

        return nil
    }
}

//MARK: - Weather ViewModel Delegate

extension WeatherTableViewController: WeatherViewModelDelegate {
    
    func updateUI() {
        tableHeaderView?.configure(with: viewModel.currentWeather)
        tableView.reloadData()
    }

    func displayLocationError() {
        let alert = UIAlertController(title: "Location Serviced Disabled",
                                      message: "Please enable your location to present current weather",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { [weak self] _ in
            guard let self else { return }
            
            self.viewModel.openSystemSettings()
        }

        alert.addAction(cancelAction)
        alert.addAction(settingsAction)

        self.present(alert, animated: true, completion: nil)
    }

    func displayInternetConnectionError() {
        let alert = UIAlertController(title: "Internet Connection Error", message: "Unable to connect. Please check your internet connection.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let retryAction = UIAlertAction(title: "Settings", style: .default) { [weak self] _ in
            guard let self else { return }

            self.viewModel.openSystemSettings()
        }

        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
}
