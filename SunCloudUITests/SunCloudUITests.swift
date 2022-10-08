//
//  SunCloudUITests.swift
//  SunCloudUITests
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import XCTest

final class SunCloudUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMaPosition() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.tabBars["Tab Bar"].buttons["Ma position"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Mercredi"]/*[[".cells.staticTexts[\"Mercredi\"]",".staticTexts[\"Mercredi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Lever du soleil"].swipeRight()/*[[".cells.staticTexts[\"Lever du soleil\"]",".swipeDown()",".swipeRight()",".staticTexts[\"Lever du soleil\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
    }
    
    func testPositionAleatoire() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.tabBars["Tab Bar"].buttons["Position aléatoire"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 10).children(matching: .other).element(boundBy: 1).children(matching: .other).element.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.swipeDown()
        
        let refreshButton = app.buttons["Refresh"]
        refreshButton.tap()
    }
    
    func testCarte() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.tabBars["Tab Bar"].buttons["Carte"].tap()
        
        let positionActuelleButton = app.buttons["Position actuelle"]
        positionActuelleButton.tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.buttons["Position aléatoire"].tap()
        positionActuelleButton.tap()
    }
    
    func testRecherche() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.tabBars["Tab Bar"].buttons["Recherche"].tap()
        
        let textField = app.scrollViews.otherElements.containing(.staticText, identifier:"Recherche").children(matching: .textField).element
        textField.tap()
        
        textField.typeText("Paris")
        
        app.buttons["Valider"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 6).children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
