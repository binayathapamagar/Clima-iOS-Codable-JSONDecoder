//
//  WeatherModel.swift
//  Clima
//
//  Created by Binaya on 26/05/2021.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let temperature: Double
    var conditionID: Int
    var tempAs1Dp: String {
        get {
            return String(format: "%.1f", temperature)
        }
    }
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud.bolt"
        }
    }
    
}
