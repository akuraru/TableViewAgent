
@protocol didSelectCell <NSObject>
@optional
- (void)didSelectCell:(id)viewObject;
@end
@protocol deleteCell <NSObject>
@optional
- (void)deleteCell:(id)viewObject;
@end
@protocol didSelectAdditionalCell <NSObject>
@optional
- (void)didSelectAdditionalCell;
@end
@protocol cellIdentifier <NSObject>
- (NSString *)cellIdentifier:(id)viewObject;
@end

@protocol count <NSObject>
- (NSUInteger)count;
@end
@protocol objectAtIndexedSubscript <NSObject>
- (id)objectAtIndexedSubscript:(NSUInteger)index;
@end
@protocol arrayByAddingObject <NSObject>
- (id)arrayByAddingObject:(id)object;
@end
@protocol filteredArrayUsingPredicate <NSObject>
- (id)filteredArrayUsingPredicate:(NSPredicate *)predicate;
@end
@protocol tableView <NSObject>
- (UITableView *)tableView;
@end

@protocol AgentViewObjectsDelegate <count, objectAtIndexedSubscript, arrayByAddingObject, filteredArrayUsingPredicate>
@end

@protocol TableViewAgentDelegate <tableView, didSelectCell, deleteCell, didSelectAdditionalCell, cellIdentifier>
@end

@interface NSArray (TableViewAgent) <AgentViewObjectsDelegate>
@end