
@protocol TableViewAgentDelegate <NSObject>
- (UITableView *)tableView;
@optional
- (void)deleteCell:(id)viewObject;
- (void)insertCell:(id)viewObject;
@end