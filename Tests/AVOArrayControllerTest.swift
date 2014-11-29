//
//  AVOArrayControllerTest.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/11/28.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//


import Foundation
import XCTest


extension NSString: ArrayController {
}

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
        XCTAssertEqual(controller.sections, [expected])
    }
    func testAddObject() {
        let addT: NSString = "unknown";
        controller.addObject(addT)
        
        let expected = AVOArrayController(array: array + [addT], groupedBy: nil, sortedBy: sortTerm)
        XCTAssertEqual(controller, expected)
    }
    
    func addArray(array: [T],_ Ts: [T]) -> [T] {
        return sortedArray(array + Ts)
    }
    func sortedArray(array: [T]) -> [T] {
        return array
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

