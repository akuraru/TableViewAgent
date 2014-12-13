//
//  FRCLikeObjectTest.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/11/28.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//


import Foundation
import XCTest
import CoreData


class AVOTestObject: NSObject, FRCLikeObjectGenerics {
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

class FRCLikeObjectTest: XCTestCase, FRCLikeObjectDelegate {
    typealias T = AVOTestObject
    var controller: FRCLikeObject<T>!
    var array: [T]! = []
    var sortTerm: ((T, T) -> Bool)! = nil
    
    override func setUp() {
        super.setUp()
        controller = FRCLikeObject(array: array, nil, sortTerm)
        controller.delegate = self
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
        let expected = FRCLikeObjectSectionInfo.create(nil, indexTitle: nil, objects: sortedArray(array))
        XCTAssertEqual(controller.sections, [expected])
    }
    func testAddObject() {
        let addT = AVOTestObject("unknown", 10);
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
        self.callController = {(anObject, indexPath, type, newIndexPath) in
            XCTAssertEqual(addT, anObject as AVOTestObject)
            XCTAssert(indexPath == nil)
            XCTAssertEqual(type, NSFetchedResultsChangeType.Insert)
            XCTAssertEqual(newIndexPath!, NSIndexPath(forRow: self.array.count, inSection: 0))
        }
        
        controller.addObject(addT)
        
        let expected = FRCLikeObject(array: array + [addT], groupedBy: nil, sortedBy: sortTerm)
        FRCLikeObjectAssertEqual(controller, expected)
    }
    func testAddObjects() {
        let addTs = [AVOTestObject("unknown", 10), AVOTestObject("warwlof", 11)]
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
        self.callController = {(anObject, indexPath, type, newIndexPath) in
            XCTAssert(indexPath == nil)
            XCTAssertEqual(type, NSFetchedResultsChangeType.Insert)
            if addTs[0] == anObject as AVOTestObject {
                XCTAssertEqual(newIndexPath!, NSIndexPath(forRow: self.array.count, inSection: 0))
            } else {
                XCTAssertEqual(addTs[1], anObject as AVOTestObject)
                XCTAssertEqual(newIndexPath!, NSIndexPath(forRow: self.array.count + 1, inSection: 0))
            }
        }
        controller.addObjects(addTs)
        
        let expected = FRCLikeObject(array: array + addTs, groupedBy: nil, sortedBy: sortTerm)
        FRCLikeObjectAssertEqual(controller, expected)
    }
    func testRemoveObject() {
        let removeT = AVOTestObject("alice", 1)
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
        self.callController = {(anObject, indexPath, type, newIndexPath) in
            XCTAssertEqual(removeT, anObject as AVOTestObject)
            XCTAssertEqual(indexPath!, NSIndexPath(forRow: 0, inSection: 0))
            XCTAssertEqual(type, NSFetchedResultsChangeType.Delete)
            XCTAssert(newIndexPath == nil)
        }
        controller.removeObject(removeT)
        
        let a = array.filter{t in t != removeT}
        let expected = FRCLikeObject(array: a, groupedBy: nil, sortedBy: sortTerm)
        FRCLikeObjectAssertEqual(controller, expected)
    }
    func testUpdateObject() {
        let updateT = AVOTestObject("arc", 1)
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
        self.callController = {(anObject, indexPath, type, newIndexPath) in
            XCTAssertEqual(updateT, anObject as AVOTestObject)
            XCTAssertEqual(indexPath!, NSIndexPath(forRow: 0, inSection: 0))
            XCTAssertEqual(type, NSFetchedResultsChangeType.Update)
            XCTAssert(newIndexPath == indexPath)
        }
        controller.updateObject(updateT)
        
        let a = array.map{t in t == updateT ? updateT : t}
        let expected = FRCLikeObject(array: a, groupedBy: nil, sortedBy: sortTerm)
        FRCLikeObjectAssertEqual(controller, expected)
    }
    func testInsertOrUpdateObject() {
        let updateT = AVOTestObject("arc", 1)
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
        self.callController = {(anObject, indexPath, type, newIndexPath) in
            XCTAssertEqual(updateT, anObject as AVOTestObject)
            if type == NSFetchedResultsChangeType.Update {
                XCTAssertEqual(indexPath!, NSIndexPath(forRow: 0, inSection: 0))
                XCTAssert(newIndexPath == indexPath)
            } else {
                XCTAssertEqual(type, NSFetchedResultsChangeType.Insert)
                XCTAssertEqual(newIndexPath!, NSIndexPath(forRow: 0, inSection: 0))
                XCTAssert(indexPath == nil)
            }
        }
        controller.insertOrUpdateObject(updateT)
        
        let a = array.filter({t in t == updateT}).isEmpty ? {
            let t = (self.array + [updateT])
            return self.sortTerm != nil ? t.sorted(self.sortTerm) : t
            }() : array.map{t in t == updateT ? updateT : t}
        let expected = FRCLikeObject(array: a, groupedBy: nil, sortedBy: sortTerm)
        FRCLikeObjectAssertEqual(controller, expected)
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
    func FRCLikeObjectAssertEqual(c1: FRCLikeObject<T>,_ c2: FRCLikeObject<T>) {
        XCTAssertEqual(c1.fetchedObjects.count, c2.fetchedObjects.count)
        for (t1, t2) in Zip2(c1.fetchedObjects, c2.fetchedObjects) {
            XCTAssert(t1.isEqualToTest(t2), "\(String(t1.string)):\(t1.identifier), \(String(t2.string)):\(t2.identifier)")
        }
        SctionInfoAssertEqual(c1.sections, c2.sections)
    }
    func SctionInfoAssertEqual(s1: [FRCLikeObjectSectionInfo<T>],_ s2: [FRCLikeObjectSectionInfo<T>]) {
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
    var callController: ((anObject: AnyObject, indexPath: NSIndexPath?, type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) -> ())!
    func controller(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if let c = callController {
            c(anObject: anObject, indexPath: indexPath, type: type, newIndexPath: newIndexPath)
        } else {
            XCTFail("don't call this delegate method")
        }
    }
    var callControllerWillChangeContent: (() -> ())!
    func controllerWillChangeContent() {
        if let c = callControllerWillChangeContent {
            c()
            self.callControllerWillChangeContent = nil
        } else {
            XCTFail("don't call this delegate method")
        }
    }
    var callControllerDidChangeContent: (() -> ())!
    func controllerDidChangeContent() {
        if let c = callControllerDidChangeContent {
            c()
            self.callControllerDidChangeContent = nil
        } else {
            XCTFail("don't call this delegate method")
        }
    }
}

class OneListTest: FRCLikeObjectTest {
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

class MoreListTest: FRCLikeObjectTest {
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

