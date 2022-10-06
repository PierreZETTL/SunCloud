//
//  WeatherRandomAPI.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 01/10/2022.
//

import Foundation
import CoreLocation

class WeatherRandomAPI : ObservableObject {
    @Published var weather: Weather = GlobalVars.defaultWeather
    
    func loadData(completion:@escaping (Weather) -> ()) {
        GlobalVars.randLatitude = Float.random(in: -89...89)
        GlobalVars.randLongitude = Float.random(in: -179...179)
        
        print("Latitude aléatoire : \(GlobalVars.randLatitude)")
        print("Longitude aléatoire : \(GlobalVars.randLongitude)")
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(CLLocationDegrees(GlobalVars.randLatitude))&longitude=\(CLLocationDegrees(GlobalVars.randLongitude))&hourly=temperature_2m,rain,cloudcover,snowfall&daily=temperature_2m_max,temperature_2m_min,rain_sum,sunrise,sunset,snowfall_sum&current_weather=true&timezone=Europe%2FParis") else {
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
