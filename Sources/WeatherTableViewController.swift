import UIKit

final class WeatherTableViewController: UITableViewController {

    //MARK: Properties

    var viewModel = WeatherViewModel()

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "DailyWeatherTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DailyWeatherCell")
        nib = UINib(nibName: "HourlyWeatherTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HourlyWeatherCell")

        viewModel.delegate = self
        viewModel.locationService.configureLocation()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.dataIsLoaded()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyWeather.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell") as! HourlyWeatherTableViewCell

            cell.configure(with: viewModel.hourlyWeather)
            cell.selectionStyle = .none

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell") as! DailyWeatherTableViewCell
        let weather = viewModel.dailyWeather[indexPath.row-1]

        cell.configure(with: weather)
        cell.selectionStyle = .none

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        let cityLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height / 5))
        let temperatureLabel = UILabel(frame: CGRect(x: 10, y: 15+cityLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height / 3))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 10+temperatureLabel.frame.size.height+cityLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height / 5))

        cityLabel.textAlignment = .center
        temperatureLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        cityLabel.text = viewModel.currentWeather.city
        cityLabel.font = UIFont(name: "Helvetica-Bold", size: 30)

        temperatureLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 80)
        temperatureLabel.text = "\(Int(viewModel.currentWeather.temperature))°"

        summaryLabel.text = viewModel.currentWeather.summary

        headerView.addSubview(cityLabel)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(summaryLabel)

        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 120
        }
        return 60
    }
}

    //MARK: - WeatherViewModel Delegate

extension WeatherTableViewController: WeatherViewModelDelegate {
    
    func updateUI(_ weatherViewModel: WeatherViewModel) {
        tableView.reloadData()
    }


}
