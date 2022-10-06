//
//  WeatherAPI.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 30/09/2022.
//

import Foundation
import CoreLocation

class WeatherAPI : ObservableObject {
    @Published var weather: Weather = GlobalVars.defaultWeather
    
    func loadData(completion:@escaping (Weather) -> ()) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(CLLocationManager().location?.coordinate.latitude ?? 0.0)&longitude=\(CLLocationManager().location?.coordinate.longitude ?? 0.0)&hourly=temperature_2m,rain,cloudcover,snowfall&daily=temperature_2m_max,temperature_2m_min,rain_sum,sunrise,sunset,snowfall_sum&current_weather=true&timezone=Europe%2FParis") else {
            print("URL invalide.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let weather = try! JSONDecoder().decode(Weather.self, from: data!)
            DispatchQueue.main.async {
                completion(weather)
            }
        }.resume()
    }
}