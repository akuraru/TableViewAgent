
@protocol TableViewAgentDelegate <NSObject>
- (NSString *)cellIdentifier:(id)viewObject;
- (UITableView *)tableView;
@optional
- (void)didSelectCell:(id)viewObject;
- (void)deleteCell:(id)viewObject;
- (id)commonViewObject:(id)viewObject;
- (NSString *)sectionTitle:(NSArray *)viewObjects;
- (NSString *)addCellIdentifier;
- (void)didSelectAdditionalCell;
- (NSString *)addSectionTitle;
- (CGFloat)addSectionHeightForHeader;
- (UIView *)addSectionHeader;
- (CGFloat)sectionHeightForHeader:(id)viewObject;
- (UIView *)sectionHeader:(id)viewObject;
- (CGFloat)cellHeight:(id)viewObject;
@end