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

    private func setUpConstraints(for header: WeatherHeaderView) {
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
//            header.heightAnchor.constraint(equalToConstant: 300),
//            header.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 200),
//            header.topAnchor.constraint(equalTo: tableView.topAnchor)
        ])
    }
}

//MARK: - WeatherViewModel Delegate

extension WeatherTableViewController: WeatherViewModelDelegate {
    
    func updateUI() {
        let nib = UINib(nibName: "WeatherHeaderView", bundle: nil)
        let header = nib.instantiate(withOwner: self, options: nil).first as! WeatherHeaderView
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints(for: header)
        header.configure(with: viewModel.currentWeather)
        view.addSubview(header)
        tableView.tableHeaderView = header
        tableView.reloadData()
    }
}
