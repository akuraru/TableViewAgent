//
// Created by akuraru on 2014/03/25.
// Copyright (c) 2014 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSFetchedResultsController.h>

@protocol NSFetchedResultsControllerDelegate;
@protocol NSFetchedResultsSectionInfo;

@interface AVOArrayController : NSObject {
@private
    NSString *_sectionNameKeyPath;
    NSString *_sectionNameKey;
    id _sortKeys;
    id _fetchedObjects;
    id _sections;
    id _sectionsByName;
    id _sectionIndexTitles;
    id _sectionIndexTitlesSections;

}

- (id)initWithArray:(NSArray *)array groupedBy:(NSString *)groupedTerm withPredicate:(NSPredicate *)searchTerm sortedBy:(NSComparisonResult (^)(id, id))sortTerm;

@property(nonatomic, readonly) NSString *sectionNameKeyPath;

@property(weak, nonatomic) id <NSFetchedResultsControllerDelegate, NSObject> delegate;

@property(nonatomic, readonly) NSMutableArray *fetchedObjects;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForObject:(id)object;

@property(nonatomic, readonly) NSArray *sections;


- (void)addObject:(id)object;

- (void)updateObject:(id)object;

- (void)updateObjects:(NSArray *)object;

- (void)removeObject:(id)object;

- (void)removeAll;

- (void)addObjects:(NSArray *)array;
@end



@interface AVOArrayControllerSectionInfo : NSObject <NSFetchedResultsSectionInfo>
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *indexTitle;
@property(nonatomic, readonly) NSUInteger numberOfObjects;
@property(nonatomic) NSArray *objects;

- (instancetype)initWithName:(NSString *)name objects:(NSArray *)objects;
@end
