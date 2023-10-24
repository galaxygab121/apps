import UIKit

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        showCityInputAlert()
    }

    func showCityInputAlert() {
        let alertController = UIAlertController(title: "Enter City", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "City Name"
        }
        let searchAction = UIAlertAction(title: "Search", style: .default) { _ in
            if let city = alertController.textFields?.first?.text, !city.isEmpty {
                self.fetchWeatherData(for: city)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func fetchWeatherData(for city: String) {
        showLoadingIndicator()

        let apiKey = "YOUR_API_KEY" // Replace with your OpenWeatherMap API key
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                }

                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            self.updateUI(with: weatherData)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showErrorMessage("Failed to decode weather data")
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        self.showErrorMessage("Failed to fetch weather data: \(error.localizedDescription)")
                    }
                }
            }.resume()
        } else {
            showErrorMessage("Invalid URL")
        }
    }

    func updateUI(with weatherData: WeatherData) {
        cityLabel.text = weatherData.name
        temperatureLabel.text = "\(weatherData.main.temp)°C"
        if let weather = weatherData.weather.first {
            conditionLabel.text = weather.description
        }
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        errorLabel.isHidden = true
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func showErrorMessage(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
