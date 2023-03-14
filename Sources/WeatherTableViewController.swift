import UIKit

final class WeatherTableViewController: UITableViewController {

    //MARK: Properties

    var viewModel: WeatherViewModel!
    private var tableHeaderView: WeatherHeaderView?

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "DailyWeatherTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DailyWeatherCell")
        nib = UINib(nibName: "HourlyWeatherTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HourlyWeatherCell")
        nib = UINib(nibName: "WeatherHeaderView", bundle: nil)
        tableHeaderView = nib.instantiate(withOwner: self, options: nil).first as? WeatherHeaderView

        tableHeaderView?.configure(with: viewModel.currentWeather)
        tableView.tableHeaderView = tableHeaderView

        viewModel.delegate = self
        viewModel.configureLocation()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell") as! HourlyWeatherTableViewCell

            cell.configure(with: viewModel.hourlyWeather)
            cell.selectionStyle = .none

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell") as! DailyWeatherTableViewCell
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

//MARK: - WeatherViewModel Delegate

extension WeatherTableViewController: WeatherViewModelDelegate {
    
    func updateUI() {
        tableHeaderView?.configure(with: viewModel.currentWeather)
        tableView.reloadData()
    }
}
