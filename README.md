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

## Idea

　UITableView is a view for displaying a particular set. The set always be defined a unique order, are sometimes grouped. The number of sets equal to the number of TableViewCell. Each elements of set holds enough information to draw TableViewCell. Since each element is independent, the interaction is not present in the Cell (interactions in Cell or without).

Each element is mapped to Cell. When mapping, `setViewObject:` element is sent to the TableViewCell by a message. Display methods and change the Cell is the responsibility. Although Cell is selected by the content of the element, it is, `cellIdentifier:` by is performed.

 



## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

MIT