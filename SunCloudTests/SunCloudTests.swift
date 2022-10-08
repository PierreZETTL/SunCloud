//
//  SunCloudTests.swift
//  SunCloudTests
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import XCTest
@testable import SunCloud

final class SunCloudTests: XCTestCase {
    
    var weather: Weather?
    
    override func setUp() {
        super.setUp()
        do {
            let testBundle = Bundle(for: type(of: self))
            if let url = testBundle.url(forResource: "Weather", withExtension: "json") {
                let jsonData = try Data(contentsOf: url)
                self.weather = try JSONDecoder().decode(Weather.self, from: jsonData)
            }
        } catch {
            print("Erreur")
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLatitude() throws {
        XCTAssertEqual(weather?.latitude, 10.0)
    }
    
    func testLongitude() throws {
        XCTAssertEqual(weather?.longitude, 10.0)
    }
    
    func testHourly() throws {
        XCTAssertNotNil(weather?.hourly)
    }
    
    func testHourlyTime() throws {
        XCTAssertEqual(weather?.hourly.time[0], "2022-10-08T00:00")
    }
    
    func testHourlyTemperature2M() throws {
        XCTAssertEqual(weather?.hourly.temperature_2m[0], 24.2)
    }
    
    func testHourlyRain() throws {
        XCTAssertEqual(weather?.hourly.rain[0], 0.0)
    }
    
    func testHourlyCloudcover() throws {
        XCTAssertEqual(weather?.hourly.cloudcover[0], 100.0)
    }
    
    func testHourlySnowfall() throws {
        XCTAssertEqual(weather?.hourly.snowfall[0], 0.0)
    }
    
    func testDaily() throws {
        XCTAssertNotNil(weather?.daily)
    }
    
    func testDailyTime() throws {
        XCTAssertEqual(weather?.daily.time[0], "2022-10-08")
    }
    
    func testDailyTemperature2mMax() throws {
        XCTAssertEqual(weather?.daily.temperature_2m_max[0], 30.7)
    }
    
    func testDailyTemperature2mMin() throws {
        XCTAssertEqual(weather?.daily.temperature_2m_min[0], 22.2)
    }
    
    func testDailyRainSum() throws {
        XCTAssertEqual(weather?.daily.rain_sum[0], 0.0)
    }
    
    func testDailySnowfallSum() throws {
        XCTAssertEqual(weather?.daily.snowfall_sum[0], 0.0)
    }
    
    func testDailySunrise() throws {
        XCTAssertEqual(weather?.daily.sunrise[0], "2022-10-08T07:07")
    }
    
    func testDailySunset() throws {
        XCTAssertEqual(weather?.daily.sunset[0], "2022-10-08T19:07")
    }
    
    func testDailyWindspeed10mMax() throws {
        XCTAssertEqual(weather?.daily.windspeed_10m_max[0], 11.4)
    }
    
    func testDailyWinddirection10mDominant() throws {
        XCTAssertEqual(weather?.daily.winddirection_10m_dominant[0], 155.32315)
    }
    
    func testCurrentWeather() throws {
        XCTAssertNotNil(weather?.current_weather)
    }
    
    func testCurrentWeatherTime() throws {
        XCTAssertEqual(weather?.current_weather.time, "2022-10-08T08:00")
    }
    
    func testCurrentWeatherTemperature() throws {
        XCTAssertEqual(weather?.current_weather.temperature, 22.9)
    }

}
