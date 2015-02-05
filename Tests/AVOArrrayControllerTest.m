#import "Kiwi.h"
#import "AVOArrayControoler.h"

@interface AVOTestObject : NSObject<NSCopying>
@property(nonatomic) NSString *string;
@property(nonatomic) NSInteger identifie;
@end

@implementation AVOTestObject
- (instancetype)initWithString:(NSString *)string identifier:(NSInteger)identifier {
    self = [super init];
    if (self) {
        self.string = string;
        self.identifie = identifier;
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
    return [@(self.identifie) compare:@([object identifie])];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSUInteger)hash {
    return self.identifie;
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

@interface AVOArrayControllerTest () <NSFetchedResultsControllerDelegate> {
    AVOArrayController *controller;
    
    void (^callControllerWillChangeContent)();
    
    void (^callControllerDidChangeContent)();
    
    void (^callController)(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath);
}
@property(strong, nonatomic) NSComparisonResult(^sortTerm)(id obj1, id obj2);
@property(nonatomic) NSArray *array;
@end

@implementation AVOArrayControllerTest
- (void)setUp {
    [super setUp];
    controller = [[AVOArrayController alloc] initWithArray:self.array groupedBy:nil withPredicate:nil sortedBy:self.sortTerm];
    [controller setDelegate:self];
}

- (void)tearDown {
    [super tearDown];
    self.array = nil;
    self.sortTerm = nil;
}

- (NSArray *)sortedArray {
    if (self.sortTerm) {
        return [self.array sortedArrayUsingComparator:self.sortTerm];
    } else {
        return self.array ?: @[];
    }
}

- (void)testFetchedObjects {
    NSArray *expected = [self sortedArray];
    XCTAssertEqualObjects(controller.fetchedObjects, expected, @"empty list");
}

- (void)testSections {
    AVOArrayControllerSectionInfo *expected = [[AVOArrayControllerSectionInfo alloc] initWithName:nil objects:[self sortedArray]];
    [self SctionInfoAssertEqual:controller.sections expected:@[expected]];
}

- (void)testAddObject {
    AVOTestObject *addT = [[AVOTestObject alloc] initWithString:@"unknown" identifier:10];
    callControllerWillChangeContent = ^{};
    callControllerDidChangeContent = ^{};
    callController = ^(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath) {
        XCTAssertEqualObjects(addT, anObject);
        XCTAssert(indexPath == nil);
        XCTAssertEqual(type, NSFetchedResultsChangeInsert);
        XCTAssertEqualObjects(newIndexPath, [NSIndexPath indexPathForRow:self.array.count inSection:0]);
    };

    [controller addObject:addT];

    AVOArrayController *expected = [[AVOArrayController alloc] initWithArray:[self.array ?: @[] arrayByAddingObject:addT] groupedBy:nil withPredicate:nil sortedBy:self.sortTerm];
    [self AVOArrayControllerAssertEqual:controller expected:expected];
}

- (void)testAddObjects {
    NSArray *addTs = @[[[AVOTestObject alloc] initWithString:@"unknown" identifier:10], [[AVOTestObject alloc] initWithString:@"warwlof" identifier:11]];
    callControllerWillChangeContent = ^{};
    callControllerDidChangeContent = ^{};
    callController = ^(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath) {
        XCTAssertTrue(indexPath == nil, "indexPath");
        XCTAssertEqual(type, NSFetchedResultsChangeInsert);
        if ([addTs[0] isEqual:anObject]) {
            XCTAssertEqual(newIndexPath, [NSIndexPath indexPathForRow:self.array.count inSection:0]);
        } else {
            XCTAssertEqual(addTs[1], anObject);
            XCTAssertEqual(newIndexPath, [NSIndexPath indexPathForRow:self.array.count + 1 inSection:0]);
        }
    };
    [controller addObjects:addTs];

    AVOArrayController *expected = [[AVOArrayController alloc] initWithArray:[self.array ?: @[] arrayByAddingObjectsFromArray:addTs] groupedBy:nil withPredicate:nil sortedBy:self.sortTerm];
    [self AVOArrayControllerAssertEqual:controller expected:expected];
}

- (void)testRemoveObject {
    AVOTestObject *removeT = [[AVOTestObject alloc] initWithString:@"alice" identifier:1];
    callControllerWillChangeContent = ^{};
    callControllerDidChangeContent = ^{};
    callController = ^(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath) {
        XCTAssertEqualObjects(removeT, anObject);
        XCTAssertEqualObjects(indexPath, [NSIndexPath indexPathForRow:0 inSection:0]);
        XCTAssertEqual(type, NSFetchedResultsChangeDelete);;
        XCTAssert(newIndexPath == nil, "hoge");
    };
    [controller removeObject:removeT];
    
    NSArray *a = self.array.count == 0 ? @[] : [self filter:self.array objects:@[removeT]];
    AVOArrayController *expected = [[AVOArrayController alloc] initWithArray:a groupedBy:nil withPredicate:nil sortedBy:self.sortTerm];
    [self AVOArrayControllerAssertEqual:controller expected:expected];
}

- (void)testUpdateObject {
    AVOTestObject *updateT = [[AVOTestObject alloc] initWithString:@"arc" identifier:1];
    if ([self.array indexOfObject:updateT] != NSNotFound) {
        callControllerWillChangeContent = ^{};
        callControllerDidChangeContent = ^{};
        callController = ^(id anObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath) {
            XCTAssertEqualObjects(updateT, anObject);
            XCTAssertEqualObjects(indexPath, [NSIndexPath indexPathForRow:0 inSection:0]);
            XCTAssertEqual(type, NSFetchedResultsChangeUpdate);;
            XCTAssert(newIndexPath == [NSIndexPath indexPathForRow:0 inSection:0], "hoge");
        };
        [controller updateObject:updateT];
        
        NSArray *a = [self update:self.array objects:@[updateT]];
        AVOArrayController *expected = [[AVOArrayController alloc] initWithArray:a groupedBy:nil withPredicate:nil sortedBy:self.sortTerm];
        [self AVOArrayControllerAssertEqual:controller expected:expected];
    } else {
        
    }
}

- (void)AVOArrayControllerAssertEqual:(AVOArrayController *)c1 expected:(AVOArrayController *)c2 {
    if (c1.fetchedObjects.count != c2.fetchedObjects.count) {
        XCTFail("count");
        return;
    }
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

- (NSArray *)update:(NSArray *)arr objects:(id)objects {
    NSMutableArray *result = [NSMutableArray array];
    for (id a in arr) {
        NSInteger index = [objects indexOfObject:a];
        if (index != NSNotFound) {
            [result addObject:objects[index]];
        } else {
            [result addObject:a];
        }
    }
    return result;
}

- (NSArray *)filter:(NSArray *)arr objects:(id)objects {
    NSMutableArray *result = [NSMutableArray array];
    for (id a in arr) {
        if ([objects indexOfObject:a] == NSNotFound) {
            [result addObject:a];
        }
    }
    return result;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (callController) {
        callController(anObject, indexPath, type, newIndexPath);
    } else {
        XCTFail("don't call this delegate method");
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (callControllerWillChangeContent) {
        callControllerWillChangeContent();
        callControllerWillChangeContent = nil;
    } else {
        XCTFail("don't call this delegate method");
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (callControllerDidChangeContent) {
        callControllerDidChangeContent();
        callControllerDidChangeContent = nil;
    } else {
        XCTFail("don't call this delegate method");
    }
}
@end


@interface OneListTest : AVOArrayControllerTest
@end

@implementation OneListTest
- (void)setUp {
    self.array = @[[[AVOTestObject alloc] initWithString:@"alice" identifier:1]];
    [super setUp];
}
@end

@interface SortedListTest: OneListTest
@end

@implementation SortedListTest

- (void)setUp {
    self.sortTerm = ^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    };
    [super setUp];
}

@end

@interface MoreListTest: AVOArrayControllerTest
@end
@implementation MoreListTest


- (void)setUp {
    self.array = @[
        [[AVOTestObject alloc] initWithString:@"alice" identifier:1],
        [[AVOTestObject alloc] initWithString:@"charlie" identifier:3],
        [[AVOTestObject alloc] initWithString:@"bob" identifier:2],
    ];
    [super setUp];
}

@end

@interface MoreSortedListTest: MoreListTest
@end
@implementation MoreSortedListTest

- (void)setUp {
    self.sortTerm = ^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    };
    [super setUp];
}

@end