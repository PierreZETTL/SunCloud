//
//  WeatherSearchAPI.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 07/10/2022.
//

import Foundation
import CoreLocation

class WeatherSearchAPI : ObservableObject {
    @Published var weather: Weather = GlobalVars.defaultWeather
    
    func loadData(completion:@escaping (Weather) -> ()) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(CLLocationDegrees(GlobalVars.searchLatitude))&longitude=\(CLLocationDegrees(GlobalVars.searchLongitude))&hourly=temperature_2m,rain,cloudcover,snowfall&daily=temperature_2m_max,temperature_2m_min,rain_sum,sunrise,sunset,snowfall_sum,windspeed_10m_max,winddirection_10m_dominant&current_weather=true&timezone=Europe%2FParis") else {
            print("URL invalide.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let weather = try? JSONDecoder().decode(Weather.self, from: data!)
            DispatchQueue.main.async {
                completion(weather  ?? GlobalVars.defaultWeather)
            }
        }.resume()
    }
}
