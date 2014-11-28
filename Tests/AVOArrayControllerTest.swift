//
//  AVOArrayControllerTest.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/11/28.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//


import Foundation
import XCTest


class AVOArrayControllerTest: XCTestCase {
    typealias T = NSString
    var controller: AVOArrayController<T>!
    var array: [T]! = []
    var sortTerm: ((T, T) -> Bool)! = nil
    
    override func setUp() {
        super.setUp()
        controller = AVOArrayController(array: array, nil, sortTerm)
    }
    override func tearDown() {
        super.tearDown()
        array = []
        sortTerm = nil
    }
    func testFetchedObjects() {
        XCTAssertEqual(controller.fetchedObjects, sortedArray(array), "empty list")
    }
    func testSections() {
        let expected = AKUArrayFetchedResultsSectionInfo();
        expected.name = nil
        expected.indexTitle = nil
        expected.objects = sortedArray(array)
        sectionInfoAssertEqual(controller.sections, [expected])
    }
    func testAddObject() {
        let addT: NSString = "unknown";
        controller.addObject(addT)
        XCTAssertEqual(controller.fetchedObjects, addArray(array, [addT]))
    }
    
    func addArray(array: [T],_ Ts: [T]) -> [T] {
        return sortedArray(array + Ts)
    }
    func sortedArray(array: [T]) -> [T] {
        return array
    }
    func sectionInfoAssertEqual(info1: [AKUArrayFetchedResultsSectionInfo] ,_ info2: [AKUArrayFetchedResultsSectionInfo]) {
        XCTAssertEqual(info1.count, info2.count)
        for (i1, i2) in Zip2(info1, info2) {
            eq(i1.name, i2.name)
            eq(i1.indexTitle, i2.indexTitle)
            eq(i1.objects as NSArray, i2.objects)
        }
    }
    func eq<T : Equatable>(expression1: @autoclosure () -> T?,_ expression2: @autoclosure () -> T?, _ message: String = "") {
        switch(expression1(), expression2()) {
        case (nil, nil):
            XCTAssert(true, message)
        case let (.Some(e1), .Some(e2)):
            XCTAssertEqual(e1, e2, message)
        case _:
            XCTFail(message)
        }
    }
}

class OneListTest: AVOArrayControllerTest {
    override func setUp() {
        array = ["alice"]
        super.setUp()
    }
}

class SortedListTest: OneListTest {
    override func setUp() {
        sortTerm = {t, u in t.compare(u) == NSComparisonResult.OrderedAscending}
        super.setUp()
    }
    override func sortedArray(a: [T]) -> [T] {
        return a.sorted(self.sortTerm)
    }
}

class MoreListTest: AVOArrayControllerTest {
    override func setUp() {
        array = ["alice", "charlie", "bob"]
        super.setUp()
    }
}

class MoreSortedListTest: MoreListTest {
    override func setUp() {
        sortTerm = {t, u in t.compare(u) == NSComparisonResult.OrderedAscending}
        super.setUp()
    }
    override func sortedArray(a: [T]) -> [T] {
        return a.sorted(self.sortTerm)
    }
}

