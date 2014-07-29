
@protocol didSelectCell <NSObject>
@optional
- (void)didSelectCell:(id)viewObject;
@end
@protocol deleteCell <NSObject>
@optional
- (void)deleteCell:(id)viewObject;
@end
@protocol cellIdentifier <NSObject>
- (NSString *)cellIdentifier:(id)viewObject;
@end
@protocol commonViewObject <NSObject>
@optional
- (id)commonViewObject:(id)viewObject;
@end
@protocol tableView <NSObject>
- (UITableView *)tableView;
@end
@protocol sectionTitle <NSObject>
@optional
- (NSString *)sectionTitle:(NSArray *)viewObjects;
@end


@protocol addCellIdentifier <NSObject>
@optional
- (NSString *)addCellIdentifier;
@end
@protocol didSelectAdditionalCell <NSObject>
@optional
- (void)didSelectAdditionalCell;
@end
@protocol addSectionTitle <NSObject>
@optional
- (NSString *)addSectionTitle;
@end

@protocol addSectionHeightForHeader <NSObject>
@optional
- (CGFloat)addSectionHeightForHeader;
@end
@protocol addSectionHeader <NSObject>
@optional
- (UIView *)addSectionHeader;
@end
@protocol sectionHeightForHeader <NSObject>
@optional
- (CGFloat)sectionHeightForHeader:(id)viewObject;
@end
@protocol sectionHeader <NSObject>
@optional
- (UIView *)sectionHeader:(id)viewObject;
@end
@protocol cellHeight <NSObject>
@optional
- (CGFloat)cellHeight:(id)viewObject;
@end


@protocol TableViewAgentDelegate <tableView, didSelectCell, deleteCell, cellIdentifier, commonViewObject, sectionTitle, addCellIdentifier, didSelectAdditionalCell, addSectionTitle, addSectionHeightForHeader, addSectionHeader, sectionHeightForHeader, sectionHeader, cellHeight>
@end