//
//  Habit_ManagementTests.swift
//  Habit ManagementTests
//
//  Created by 한수진 on 2022/03/24.
//

import XCTest
import RealmSwift
@testable import Habit_Management

class Habit_ManagementTests: XCTestCase {
//    let name = "test"
    let habit = Habit(name: "test", iter: [1, 2, 3, 4])
    // Test Code
    let realmPath = URL(fileURLWithPath: "...")
    var habitVM: HabitVM?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.habitVM = HabitVM()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
    }
    
    func testWeekIter() {
        let isValid = habit.isWeekValidate()
        XCTAssertTrue(isValid, "false 나왔어")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testgetWeekStr() {
        let realm = try! Realm()
        let habit = Habit(name: "test name", iter: [1,7])
        
        let result = habitVM!.getWeekStr(habit: habit)
        
        XCTAssert(result == "주말")

    }
    
    func testgetArrayIter() {
        let habit = Habit(name: "test name", iter: [1,7])
        let result = habitVM!.getArrayIter(at: habit)
        XCTAssert(result==[1,7])
    }

    func testWithProjection() {
        let realm = try! Realm()
        // Create a Realm object, populate it with values
        let habit = Habit(name: "test name", iter: [1,2,3])
        try! realm.write {
            realm.add(habit)
        }
        let person = realm.objects(Habit.self).first(where: { $0.name == "test name" })!
        XCTAssert(person.name == "test name")

        XCTAssert(Array(person.weekIter) == [1,2,3])
        // Change a value on the class projection
        try! realm.write {
            person.name = "David"
        }

        XCTAssert(person.name == "David")
    }

}
