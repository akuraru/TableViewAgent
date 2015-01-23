#import "Kiwi.h"
#import "AVOArrayControoler.h"

@interface AVOTestObject : NSObject
@property(nonatomic) NSString *string;
@property(nonatomic) NSInteger identifie;
@end

@implementation AVOTestObject
- (instancetype)initWithString:(NSString *)string identifier:(NSInteger)identifier {
    self = [super init];
    if (self) {
        self.string = string;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[AVOTestObject class]] &&
            self.identifie == (NSInteger) [object identifie];
}

- (BOOL)isEqualToTest:(id)object {
    return [object isKindOfClass:[AVOTestObject class]] &&
            [self.string isEqualToString:[object string]] &&
            self.identifie == (NSInteger) [object identifie];
}

- (NSComparisonResult)compare:(id)object {
    return [@(self.identifie) compare:@([self identifie])];
}
@end

@interface AVOArrayController ()
@property(nonatomic) NSMutableArray *fetchedObjects;
@property(nonatomic) NSString *sectionNameKeyPath;
@property(nonatomic) NSString *sectionNameKey;
@property(nonatomic) NSArray *sections;
@property(nonatomic) id sectionsByName;
@property(nonatomic) id sectionIndexTitlesSections;
@property(nonatomic) NSArray *sortKeys;
@property(nonatomic) NSArray *sortDescriptors;
@property(nonatomic) NSPredicate *searchTerm;
@property(nonatomic) NSDictionary *arrayIndexPath;
@end

@interface AVOArrayControllerTest : XCTestCase
@end

NSArray *sortedArray(NSArray *array) {
    return [array sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

@implementation AVOArrayControllerTest {
    AVOArrayController *controller;
    NSArray *array;
    BOOL (^sortTerm)(id obj1, id obj2);
    
    void (^callControllerWillChangeContent)();
    void (^callControllerDidChangeContent)();
    void (^callController)(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath);
}
- (void)setUp {
    [super setUp];
    controller = [[AVOArrayController alloc] initWithArray:array groupedBy:nil withPredicate:nil sortedBy:nil ascending:YES];
//    [controller setDelegate:self];
}

- (void)tearDown {
    [super tearDown];
    array = @[];
    sortTerm = nil;
}

- (void)testFetchedObjects {
    XCTAssertEqual(controller.fetchedObjects, sortedArray(array), @"empty list");
}

- (void)testSections {
    AVOArrayControllerSectionInfo *expected = [[AVOArrayControllerSectionInfo alloc] initWithName:nil objects:sortedArray(array)];
    XCTAssertEqualObjects(controller.sections, @[expected]);
}

- (void)testAddObject {
    AVOTestObject *addT = [[AVOTestObject alloc] initWithString:@"unknown" identifier:10];
    callControllerWillChangeContent = ^{};
    callControllerDidChangeContent = ^{};
    callController = ^(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath) {
        XCTAssertEqualObjects(addT, anObject);
        XCTAssert(indexPath == nil);
        XCTAssertEqual(type, NSFetchedResultsChangeInsert);
        XCTAssertEqualObjects(newIndexPath, [NSIndexPath indexPathForRow:array.count inSection:0]);
    };

    [controller addObject:addT];

    AVOArrayController *expected = [[AVOArrayController alloc] initWithArray:array groupedBy:nil withPredicate:nil sortedBy:nil ascending:YES];
    [self AVOArrayControllerAssertEqual:controller expected:expected];
}

- (void)AVOArrayControllerAssertEqual:(AVOArrayController *)controller expected:(AVOArrayController *)expected {

}

- (void)AVOArrayControllerAssertEqual:(AVOArrayController *)c1 ecpected:(AVOArrayController *)c2; {
    XCTAssertEqual(c1.fetchedObjects.count, c2.fetchedObjects.count);
    for (int i = 0; i < c1.fetchedObjects.count; ++i) {
        id t1 = c1.fetchedObjects[i];
        id t2 = c2.fetchedObjects[i];
        XCTAssert([t1 isEqualToTest:t2], @"{\n %@: %zd,\n %@: %zd", [t1 string], [t1 identifie], [t2 string], [t2 identifie]);
    }
    [self SctionInfoAssertEqual:c1.sections expected:c2.sections];
}

- (void)SctionInfoAssertEqual:(NSArray *)s1 expected:(NSArray *)s2 {
    XCTAssertEqual(s1.count, s2.count);
    for (int i = 0; i < s1.count; ++i) {
        AVOArrayControllerSectionInfo *i1 = s1[i];
        AVOArrayControllerSectionInfo *i2 = s2[i];
        XCTAssertEqualObjects(i1.name, i2.name);
        XCTAssertEqualObjects(i1.indexTitle, i2.indexTitle);
        for (int i = 0; i < i1.objects.count; ++i) {
            id t1 = i1.objects[i];
            id t2 = i2.objects[i];
            XCTAssert([t1 isEqualToTest:t2], @"{\n %@: %zd,\n %@: %zd", [t1 string], [t1 identifie], [t2 string], [t2 identifie]);
        }
    }
}
@end


/*
    - (void)testAddObjects {
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

        let expected = AVOArrayController(array: array + addTs, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    - (void)testRemoveObject {
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
        let expected = AVOArrayController(array: a, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    - (void)testUpdateObject {
        let updateT = AVOTestObject("arc", 1)
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
        controller.updateObject(updateT)

        let a = array.map{t in t == updateT ? updateT : t}
        let expected = AVOArrayController(array: a, groupedBy: nil, sortedBy: sortTerm)
        AVOArrayControllerAssertEqual(controller, expected)
    }
    - (void)testInsertOrUpdateObject {
        let updateT = AVOTestObject("arc", 1)
        self.callControllerWillChangeContent = {}
        self.callControllerDidChangeContent = {}
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
            func controllerWillChangeContent {
        if let c = callControllerWillChangeContent {
                c()
                self.callControllerWillChangeContent = nil
            } else {
            XCTFail("don't call this delegate method")
        }
    }
    var callControllerDidChangeContent: (() -> ())!
            func controllerDidChangeContent {
        if let c = callControllerDidChangeContent {
                c()
                self.callControllerDidChangeContent = nil
            } else {
            XCTFail("don't call this delegate method")
        }
    }
}

class OneListTest: AVOArrayControllerTest {
    override func setUp {
        array = [AVOTestObject("alice", 1)]
        super.setUp()
    }
}

class SortedListTest: OneListTest {
    override func setUp {
        sortTerm = {(t: AVOTestObject, u: AVOTestObject) in t.identifier < u.identifier}
        super.setUp()
    }
    override func sortedArray(a: [T]) -> [T] {
        return a.sorted(self.sortTerm)
    }
}

class MoreListTest: AVOArrayControllerTest {
    override func setUp {
        array = [AVOTestObject("alice", 1), AVOTestObject("charlie", 3), AVOTestObject("bob", 2)]
        super.setUp()
    }
}

class MoreSortedListTest: MoreListTest {
    override func setUp {
        sortTerm = {(t: AVOTestObject, u: AVOTestObject) in t.identifier < u.identifier}
        super.setUp()
    }
    override func sortedArray(a: [T]) -> [T] {
        return a.sorted(self.sortTerm)
    }
}
*/
