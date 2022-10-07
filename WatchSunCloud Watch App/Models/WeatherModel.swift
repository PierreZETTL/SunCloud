//
//  WeatherModel.swift
//  WatchSunCloud Watch App
//
//  Created by Pierre ZETTL on 07/10/2022.
//

import Foundation

struct Weather: Codable {
    let latitude: Float
    let longitude: Float
    let current_weather: CurrentData
}

struct CurrentData: Codable {
    let time: String
    let temperature: Float
}
