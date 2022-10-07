//
//  WeatherRandomAPI.swift
//  WatchSunCloud Watch App
//
//  Created by Pierre ZETTL on 07/10/2022.
//

import Foundation
import CoreLocation

class WeatherRandomAPI : ObservableObject {
    @Published var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, current_weather: CurrentData(time: "", temperature: 0.0))
    
    func loadData(completion:@escaping (Weather) -> ()) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(CLLocationDegrees(Float.random(in: -84...84)))&longitude=\(CLLocationDegrees(Float.random(in: -179...179)))&hourly=temperature_2m,rain,cloudcover,snowfall&daily=temperature_2m_max,temperature_2m_min,rain_sum,sunrise,sunset,snowfall_sum,windspeed_10m_max,winddirection_10m_dominant&current_weather=true&timezone=Europe%2FParis") else {
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
