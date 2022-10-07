//
//  ContentView.swift
//  WatchSunCloud Watch App
//
//  Created by Pierre ZETTL on 07/10/2022.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @State var weather: Weather = Weather(latitude: 0.0, longitude: 0.0, current_weather: CurrentData(time: "", temperature: 0.0))
    
    // Variables position
    @State var cityName = ""
    @State var countryName = ""
    
    // Récupération infos position
    struct ReversedGeoLocation {
        let city: String
        let country: String
        init(with placemark: CLPlacemark) {
            self.city = placemark.locality ?? ""
            self.country = placemark.country ?? ""
        }
    }
    func reverseGeocode() {
        let location = CLLocation(latitude: CLLocationDegrees(weather.latitude), longitude: CLLocationDegrees(weather.longitude))
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            self.cityName = reversedGeoLocation.city
            self.countryName = reversedGeoLocation.country
            print("Ville : \(reversedGeoLocation.city)")
            print("Pays : \(reversedGeoLocation.country)")
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(cityName != "" ? cityName : "Ville inconnue")
                .lineLimit(1)
            Text(countryName != "" ? countryName : "Pays inconnu")
                .lineLimit(1)
            Spacer()
            Text("\(String(format: "%.0f", weather.current_weather.temperature)) °C")
                .font(.system(size: 45))
                .fontWeight(.thin)
            Spacer()
            Button {
                WeatherRandomAPI().loadData { (weather) in
                    self.weather = weather
                    self.reverseGeocode()
                }
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .imageScale(.large)
                    .frame(width: 35, height: 35, alignment: .center)
                    .background(Color.blue.opacity(0.65))
                    .cornerRadius(15)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 15)
            .buttonStyle(.plain)
        }
        .onAppear {
            // CLLocationManager().requestWhenInUseAuthorization()
            WeatherRandomAPI().loadData { (weather) in
                self.weather = weather
                self.reverseGeocode()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
