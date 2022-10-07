//
//  MapView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 06/10/2022.
//

import SwiftUI
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct MapView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    @State var place = IdentifiablePlace(lat: Double(GlobalVars.randLatitude), long: Double(GlobalVars.randLongitude))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [place]) { place in
                MapMarker(coordinate: place.location, tint: Color.red)
            }
            .ignoresSafeArea()
            VStack {
                HStack {
                    VStack {
                        Image(systemName: "paperplane.fill")
                        Text("\(String(format: "%.0f", GlobalVars.currentTemp))°")
                    }
                    .frame(width: 45, height: 45, alignment: .center)
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
                    .padding(.leading, 15)
                    Spacer()
                    VStack {
                        Image(systemName: "dice.fill")
                        Text("\(String(format: "%.0f", GlobalVars.currentTempRand))°")
                    }
                    .frame(width: 45, height: 45, alignment: .center)
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
                    .padding(.trailing, 15)
                }
                .padding(.top, 5)
                Spacer()
                HStack {
                    Button {
                        withAnimation {
                            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                        }
                    } label: {
                        Text("Position actuelle")
                            .frame(width: 175, height: 45, alignment: .center)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                    Button {
                        withAnimation {
                            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(GlobalVars.randLatitude), longitude: CLLocationDegrees(GlobalVars.randLongitude)), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                            self.place = IdentifiablePlace(lat: Double(GlobalVars.randLatitude), long: Double(GlobalVars.randLongitude))
                        }
                    } label: {
                        Text("Position aléatoire")
                            .frame(width: 175, height: 45, alignment: .center)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
