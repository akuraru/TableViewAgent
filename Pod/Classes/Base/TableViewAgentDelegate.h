
@protocol TableViewAgentDelegate <NSObject>
- (UITableView *)tableView;
@optional
- (void)didSelectCell:(id)viewObject;

- (void)deleteCell:(id)viewObject;
- (void)insertCell:(id)viewObject;

- (id)commonViewObject:(id)viewObject;
- (NSString *)sectionTitle:(NSArray *)viewObjects;

- (CGFloat)sectionHeightForHeader:(id)viewObject;
- (UIView *)sectionHeader:(id)viewObject;
- (CGFloat)cellHeight:(id)viewObject;
@end