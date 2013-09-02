
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
@protocol tableView <NSObject>
- (UITableView *)tableView;
@end
@protocol addSectionTitle <NSObject>
@optional
- (NSString *)addSectionTitle;
@end
@protocol sectionTitle <NSObject>
@optional
- (NSString *)sectionTitle:(NSArray *)viewObjects;
@end

@protocol TableViewAgentDelegate <tableView, didSelectCell, deleteCell, didSelectAdditionalCell, cellIdentifier, addSectionTitle, sectionTitle>
@end