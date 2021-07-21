//
//  WeatherManager.swift
//  Clima
//
//  Created by Binaya on 24/05/2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, _ weatherModel: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherByCityURL = "https://api.openweathermap.org/data/2.5/weather?appid=&units=metric"
    
    let weatherByGeoCoordinatesURL = "https://api.openweathermap.org/data/2.5/weather?appid=&units=metric"
    
    func fetchWeather(with cityName: String) {
        let apiURL = "\(weatherByCityURL)&q=\(cityName)"
        performRequest(with: apiURL)
    }
    
    func fetchWeather(with coordinates: CLLocationCoordinate2D) {
        let apiURL = "\(weatherByGeoCoordinatesURL)&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)"
        performRequest(with: apiURL)
    }
    
    func performRequest(with url: String) {
        if let url = URL(string: url) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                
                if let e = error {
                    delegate?.didFailWithError(e)
                    return
                }
                
                if let weatherData = data {
                    // WeatherModel's instance is an Optional, as decoding can fail.
                    
                    if let weatherModel = parseJSON(with: weatherData) {
                        delegate?.didUpdateWeather(self, weatherModel)
                    }
                    
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(with data: Data) -> WeatherModel? {
        let jsonDecoder = JSONDecoder()
        do {
            let parsedData = try jsonDecoder.decode(WeatherData.self, from: data)
            let name = parsedData.name
            let temp = parsedData.main.temp
            let conditionCode = parsedData.weather[0].id
            let weatherModel = WeatherModel(cityName: name, temperature: temp, conditionID: conditionCode)
            return weatherModel
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
    
}

// MARK: - WeatherManagerDelegate's extension

extension WeatherManagerDelegate {
    
    // Optional methods:
    
    func didUpdateWeather (_ weatherManager: WeatherManager, _ weatherModel: WeatherModel) {}
    func didFailWithError(_ error: Error){}

    
}
