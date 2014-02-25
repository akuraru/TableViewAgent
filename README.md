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


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

MIT