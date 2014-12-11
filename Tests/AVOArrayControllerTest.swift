//
//  AVOArrayControllerTest.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/11/28.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//


import Foundation
import XCTest
import CoreData

extension NSString: ArrayController {
}

class AVOTestObject: NSObject, ArrayController {
    let string: NSString
    let identifier: Int
    init(_ string: NSString,_ identifier: Int) {
        self.string = string
        self.identifier = identifier
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        return self
    }
    override func isEqual(object: AnyObject?) -> Bool {
        if let rhs = object as? AVOTestObject {
            return self.identifier == rhs.identifier
        } else {
            return false
        }
    }
    func isEqualToTest(object: AnyObject?) -> Bool {
        if let rhs = object as? AVOTestObject {
            return self.identifier == rhs.identifier && self.string.isEqualToString(rhs.string)
        } else {
            return false
        }
    }
}

func ==(lhs: AVOTestObject, rhs: AVOTestObject) -> Bool {
    return lhs.identifier == rhs.identifier
}

class AVOArrayControllerTest: XCTestCase, AVOArrayControllerDelegate {
    typealias T = AVOTestObject
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
        let expected = AVOArraySectionInfo.create(nil, indexTitle: nil, objects: sortedArray(array))
        XCTAssertEqual(controller.sections, [expected])
    }
    func testAddObject() {
        let addT = AVOTestObject("unknown", 10);
        
        controller.addObject(addT)
        
        let expected = AVOArrayController(array: array + [addT], groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    func testAddObjects() {
        let addTs = [AVOTestObject("unknown", 10), AVOTestObject("warwlof", 11)]
        controller.addObjects(addTs)
        
        let expected = AVOArrayController(array: array + addTs, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    func testRemoveObject() {
        let removeT = AVOTestObject("alice", 1)
        controller.removeObject(removeT)
        
        let a = array.filter{t in t != removeT}
        let expected = AVOArrayController(array: a, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    func testUpdateObject() {
        let updateT = AVOTestObject("arc", 1)
        controller.updateObject(updateT)
        
        let a = array.map{t in t == updateT ? updateT : t}
        let expected = AVOArrayController(array: a, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    func testInsertOrUpdateObject() {
        let updateT = AVOTestObject("arc", 1)
        controller.insertOrUpdateObject(updateT)
        
        let a = array.filter({t in t == updateT}).isEmpty ? {
            let t = (self.array + [updateT])
            return self.sortTerm != nil ? t.sorted(self.sortTerm) : t
            }() : array.map{t in t == updateT ? updateT : t}
        let expected = AVOArrayController(array: a, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    func addArray(array: [T],_ Ts: [T]) -> [T] {
        return sortedArray(array + Ts)
    }
    func sortedArray(array: [T]) -> [T] {
        return array
    }
    
    var checkControllerWillChangeContent: (NSFetchedResultsController -> ())!
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        checkControllerWillChangeContent(controller)
    }
    func AVOArrayControllerAssertEqual(c1: AVOArrayController<T>,_ c2: AVOArrayController<T>) {
        XCTAssertEqual(c1.fetchedObjects.count, c2.fetchedObjects.count)
        for (t1, t2) in Zip2(c1.fetchedObjects, c2.fetchedObjects) {
            XCTAssert(t1.isEqualToTest(t2), "\(String(t1.string)):\(t1.identifier), \(String(t2.string)):\(t2.identifier)")
        }
        SctionInfoAssertEqual(c1.sections, c2.sections)
    }
    func SctionInfoAssertEqual(s1: [AVOArraySectionInfo<T>],_ s2: [AVOArraySectionInfo<T>]) {
        XCTAssertEqual(s1.count, s2.count)
        for (i1, i2) in Zip2(s1, s2) {
            eq(i1.name, i2.name)
            eq(i1.indexTitle, i2.indexTitle)
            for (t1, t2) in Zip2(i1.objects as [T], i2.objects as [T]) {
                XCTAssert(t1.isEqualToTest(t2), "\(String(t1.string)):\(t1.identifier), \(String(t2.string)):\(t2.identifier)")
            }
        }
    }
    func eq<T: Equatable>(o1: T?,_ o2: T?) {
        switch (o1, o2) {
        case let (.Some(v1), .Some(v2)):
            XCTAssertEqual(v1, v2)
        case (nil, nil):
            XCTAssert(true)
        case _:
            XCTFail("false")
        }
    }
}

class OneListTest: AVOArrayControllerTest {
    override func setUp() {
        array = [AVOTestObject("alice", 1)]
        super.setUp()
    }
}

class SortedListTest: OneListTest {
    override func setUp() {
        sortTerm = {(t: AVOTestObject, u: AVOTestObject) in t.identifier < u.identifier}
        super.setUp()
    }
    override func sortedArray(a: [T]) -> [T] {
        return a.sorted(self.sortTerm)
    }
}

class MoreListTest: AVOArrayControllerTest {
    override func setUp() {
        array = [AVOTestObject("alice", 1), AVOTestObject("charlie", 3), AVOTestObject("bob", 2)]
        super.setUp()
    }
}

class MoreSortedListTest: MoreListTest {
    override func setUp() {
        sortTerm = {(t: AVOTestObject, u: AVOTestObject) in t.identifier < u.identifier}
        super.setUp()
    }
    override func sortedArray(a: [T]) -> [T] {
        return a.sorted(self.sortTerm)
    }
}

