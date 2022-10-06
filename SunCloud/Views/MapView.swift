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
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    @State var place = IdentifiablePlace(lat: Double(GlobalVars.randLatitude), long: Double(GlobalVars.randLongitude))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [place]) { place in
                MapMarker(coordinate: place.location, tint: Color.red)
            }
            .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Button("Position actuelle") {
                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                    }
                    .frame(width: 175, height: 45, alignment: .center)
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                    Button("Position aléatoire") {
                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(GlobalVars.randLatitude), longitude: CLLocationDegrees(GlobalVars.randLongitude)), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                        self.place = IdentifiablePlace(lat: Double(GlobalVars.randLatitude), long: Double(GlobalVars.randLongitude))
                    }
                    .frame(width: 175, height: 45, alignment: .center)
                    .background(Color(UIColor.tertiarySystemBackground))
                    .cornerRadius(10)
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
