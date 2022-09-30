//
//  WeatherAPI.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 30/09/2022.
//

import Foundation
import CoreLocation

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
}

struct DailyData: Codable {
    let time: [String]
    let temperature_2m_max: [Float]
    let temperature_2m_min: [Float]
}

struct CurrentData: Codable {
    let time: String
    let temperature: Float
}

class WeatherAPI : ObservableObject{
    @Published var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15]), daily: DailyData(time: ["2022-09-30"], temperature_2m_max: [6.5], temperature_2m_min: [4.5]), current_weather: CurrentData(time: "test", temperature: 0.0))
    
    func loadData(completion:@escaping (Weather) -> ()) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(CLLocationManager().location?.coordinate.latitude ?? 0.0)&longitude=\(CLLocationManager().location?.coordinate.longitude ?? 0.0)&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&timezone=Europe%2FParis") else {
            print("URL invalide.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let weather = try! JSONDecoder().decode(Weather.self, from: data!)
            print(weather)
            DispatchQueue.main.async {
                completion(weather)
            }
        }.resume()
    }
}
