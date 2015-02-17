
@protocol TableViewAgentDelegate <NSObject>
- (UITableView *)tableView;
@optional
- (void)deleteCell:(id)viewObject;
- (void)insertCell:(id)viewObject;

- (CGFloat)sectionHeightForHeader:(id)viewObject;
- (UIView *)sectionHeader:(id)viewObject;
@end