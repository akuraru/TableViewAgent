// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Todo.h instead.

#import <CoreData/CoreData.h>

extern const struct TodoAttributes {
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *title;
} TodoAttributes;

@interface TodoID : NSManagedObjectID {}
@end

@interface _Todo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TodoID* objectID;

@property (nonatomic, strong) NSString* message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _Todo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end
