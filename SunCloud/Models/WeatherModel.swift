//
//  WeatherModel.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 01/10/2022.
//

import Foundation

struct Weather: Codable {
    let latitude: Float
    let longitude: Float
    let hourly: HourlyData
    let daily: DailyData
    let current_weather: CurrentData
}

struct HourlyData: Codable {
    let time: [String]
    let temperature_2m: [Float]
    let rain: [Float]
    let cloudcover: [Float]
    let snowfall: [Float]
}

struct DailyData: Codable {
    let time: [String]
    let temperature_2m_max: [Float]
    let temperature_2m_min: [Float]
    let rain_sum: [Float]
    let snowfall_sum: [Float]
}

struct CurrentData: Codable {
    let time: String
    let temperature: Float
}
