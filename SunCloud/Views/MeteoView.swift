//
//  MeteoView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 06/10/2022.
//

import SwiftUI
import CoreLocation

struct MeteoView: View {
    // Variables d'environnement
    @Environment(\.colorScheme) var colorScheme
    
    // Variable type de vue
    @State var type: String
    
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
        let location = type != "random" ? CLLocation(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0) : CLLocation(latitude: CLLocationDegrees(GlobalVars.randLatitude), longitude: CLLocationDegrees(GlobalVars.randLongitude))
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            self.cityName = reversedGeoLocation.city
            self.countryName = reversedGeoLocation.country
            print("Ville : \(reversedGeoLocation.city)")
            print("Pays : \(reversedGeoLocation.country)")
        }
    }
    
    // Variable données météo
    @State var weather: Weather = GlobalVars.defaultWeather
    
    // Variables dates & prévisions
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    @State var currentDay = Calendar.current.component(.weekday, from: Date())
    @State var previsionsbh = [Int]()
    @State var previsionsbd = [Int]()
    let weekdays = [1: "Dimanche", 2: "Lundi", 3: "Mardi", 4: "Mercredi", 5: "Jeudi", 6: "Vendredi", 7: "Samedi"]
    
    // Variable animation fond
    @State private var animateGradient = true
        
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.85), colorScheme != .dark ? .yellow.opacity(0.85) : .orange.opacity(0.85)], startPoint: animateGradient ? .topLeading : .topTrailing, endPoint: animateGradient ? .bottomTrailing : .bottomLeading)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            List {
                Section(header: Spacer(minLength: 0)) {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(countryName != "" ? countryName : "Pays inconnu")")
                                .font(.system(size: 20))
                                .frame(height: 25)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("\(cityName != "" ? cityName : "Ville inconnue")")
                                .font(.system(size: 30))
                                .frame(height: 35)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("\(String(format: "%.0f", weather.current_weather.temperature))°")
                                .font(.system(size: 100))
                                .fontWeight(.thin)
                                .frame(height: 70)
                            Spacer()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.blue.opacity(0))
                Section("🕦 Prévisions sur 5 heures") {
                    HStack(alignment: .center) {
                        Spacer()
                        ForEach(previsionsbh, id: \.self) { i in
                            VStack(alignment: .center) {
                                if i == currentHour {
                                    Text("Act.")
                                        .padding(.horizontal, 9.0)
                                        .fontWeight(.semibold)
                                } else {
                                    if i > 24 {
                                        Text("\(i-24) h")
                                            .padding(.horizontal, 9.0)
                                    } else {
                                        Text("\(i) h")
                                            .padding(.horizontal, 9.0)
                                    }
                                }
                                if weather.hourly.snowfall[i] > 0 {
                                    Image(systemName: "cloud.snow.fill")
                                        .padding(.horizontal, 9.0)
                                        .padding(.vertical, 1.0)
                                        .foregroundColor(Color.white)
                                } else if weather.hourly.rain[i] > 0 {
                                    Image(systemName: "cloud.rain.fill")
                                        .padding(.horizontal, 9.0)
                                        .padding(.vertical, 1.0)
                                        .foregroundColor(Color.white)
                                } else if weather.hourly.cloudcover[i] > 0 {
                                    if i < 8 || i > 20 {
                                        Image(systemName: "cloud.moon.fill")
                                            .padding(.horizontal, 9.0)
                                            .padding(.vertical, 1.0)
                                            .foregroundColor(Color.white)
                                    } else {
                                        Image(systemName: "cloud.sun.fill")
                                            .padding(.horizontal, 9.0)
                                            .padding(.vertical, 1.0)
                                            .foregroundColor(Color.yellow)
                                    }
                                } else {
                                    if i < 8 || i > 20 {
                                        Image(systemName: "moon.stars.fill")
                                            .padding(.horizontal, 9.0)
                                            .padding(.vertical, 1.0)
                                            .foregroundColor(Color.white)
                                    } else {
                                        Image(systemName: "sun.max.fill")
                                            .padding(.horizontal, 9.0)
                                            .padding(.vertical, 1.0)
                                            .foregroundColor(Color.yellow)
                                    }
                                }
                                if i == currentHour {
                                    Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                        .padding(.horizontal, 9.0)
                                        .fontWeight(.semibold)
                                } else {
                                    Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                        .padding(.horizontal, 9.0)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.blue.opacity(0.65))
                Section("📆 Prévisions sur 6 jours") {
                    ForEach(previsionsbd, id: \.self) { i in
                        HStack {
                            if weather.daily.snowfall_sum[i] > 0 {
                                Image(systemName: "cloud.snow.fill")
                                    .foregroundColor(Color.white)
                                    .frame(width: 25)
                            } else if weather.daily.rain_sum[i] > 0 {
                                Image(systemName: "cloud.rain.fill")
                                    .foregroundColor(Color.white)
                                    .frame(width: 25)
                            } else {
                                Image(systemName: "sun.max.fill")
                                    .frame(width: 25)
                                    .foregroundColor(Color.yellow)
                            }
                            if i == 0 {
                                Text("Aujourd'hui")
                                    .fontWeight(.semibold)
                            } else if currentDay+i > 7 {
                                Text(weekdays[currentDay+(i-7)] ?? "Erreur")
                            } else {
                                Text(weekdays[currentDay+i] ?? "Erreur")
                            }
                            Spacer()
                            if i == 0 {
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_min[i]))°")
                                    .fontWeight(.semibold)
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 165/255, green: 210/255, blue: 120/255), Color(red: 255/255, green: 180/255, blue: 0/255)]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                                    .frame(width: 60, height: 2)
                                    .cornerRadius(25)
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_max[i]))°")
                                    .fontWeight(.semibold)
                            } else {
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_min[i]))°")
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 165/255, green: 210/255, blue: 120/255), Color(red: 255/255, green: 180/255, blue: 0/255)]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                                    .frame(width: 60, height: 2)
                                    .cornerRadius(25)
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_max[i]))°")
                            }
                        }
                    }
                }
                .listRowBackground(Color.blue.opacity(0.65))
            }
            .scrollContentBackground(.hidden)
            .foregroundColor(Color.white)
            
            if type == "random" {
                VStack {
                    Button("Nouveau lieu") {
                        GlobalVars.randLatitude = Float.random(in: -84...84)
                        GlobalVars.randLongitude = Float.random(in: -179...179)
                        WeatherRandomAPI().loadData { (weather) in
                            self.weather = weather
                            self.reverseGeocode()
                            self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4]
                            self.previsionsbd = [0, 1, 2, 3, 4, 5]
                        }
                    }
                    .frame(width: 150, height: 25, alignment: .center)
                    .background(Color.blue.opacity(0.65))
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                    Spacer()
                }
            }
        }
        .onAppear {
            if self.type != "random" {
                CLLocationManager().requestWhenInUseAuthorization()
                WeatherAPI().loadData { (weather) in
                    self.weather = weather
                    self.reverseGeocode()
                    self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4]
                    self.previsionsbd = [0, 1, 2, 3, 4, 5]
                }
            } else {
                WeatherRandomAPI().loadData { (weather) in
                    self.weather = weather
                    self.reverseGeocode()
                    self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4]
                    self.previsionsbd = [0, 1, 2, 3, 4, 5]
                }
            }
        }
    }
}

struct MeteoView_Previews: PreviewProvider {
    static var previews: some View {
        MeteoView(type: "default")
    }
}
