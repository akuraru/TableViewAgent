# TableViewAgent

library that wraps the delegate and datesource of UITableView



## Installation

### CocoaPods

1. ``pod 'TableViewAgent'``

## Usage

1. used `dequeueReusableCellWithIdentifier:` UITableView to return the instance
2. implement `setViewObject:` to returned the instance 
3. Declare an member variable of the TableViewAgent
4. TableViewAgent setting in `viewDidload`
5. implement `cellIdentifier:` to viewController

``` objc
@implementation CustomViewController {
    TableViewAgent *agent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    agent = [[TableViewAgent alloc] init];
    agent.viewObjects = [[FRCAgentViewObject alloc] initWithFetch:fetchResultController];
    agent.delegate = self;
}

- (NSString *)cellIdentifier:(id)viewObject {
    return @"Cell";
}
@end

@implementation CustomTableViewCell

- (void)setViewObject:(Model *)model {
    self.textLabel.text = model.text;
}

@end
```

## 思想
　
 UITableViewは、特定の集合を表示させるためのViewである。特定の集合は、必ず一意の順序が規定でき、時としてグループ化されている。集合の個数はCellの数と等しく、各集合の要素はCellを描画するために十分な情報を保持している。各要素は独立しているため、各Cellの相互作用は存在しない(Cell内の相互作用は有無を問わない)。

 各要素はCellに写像される。写像する際、`setViewObject:`のメッセージによって要素がCellに送られる。Cellの表示方法や変更は責務である。要素の内容によってCellが選択されるが、それは、`cellIdentifier:`によって行われる。

 



## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

MIT