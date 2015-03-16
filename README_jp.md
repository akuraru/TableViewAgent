# TableViewAgent

このライブラリはUITableViewのdelegateとdatesourceをラップするためのライブラリです。

## インストール方法

### CocoaPods

1. ``pod 'TableViewAgent'``

## 使い方

1. UITableViewの `dequeueReusableCellWithIdentifier:`を使ったときにUITableViewCellを継承したインスタンスが帰るようにしてください。
2. そのインスタンスは`setViewObject:`を実装している必要があります。
3. TableViewAgentをメンバー変数として宣言してください。
4. `viewDidload`でTableViewAgentを初期化してください。
5. 任意の集合を`AgentViewObject`でラップして、TableViewAgentに渡してください。

```
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

### TableViewAgent

基本となるクラス。UITableViewから委譲される処理を仲介する。AgentViewObjectからデータを受け取り、加工し、UITableViewに受け渡す。セクションの数や並びはAgentViewObjectで決定している。

### AgentViewObject

AgentViewObjectは、集合ををラップしてAgentに対して受け渡すための機能である。各AgentViewObjectには特色があり、表示のされ方が異なる。

`@property(copy, nonatomic) NSString *(^cellIdentifer)(id viewObject);`

各セルの要素からcell identiferを返す。

`@property(copy, nonatomic) void (^didSelectCell)(id viewObject);`

各セルが選択されたときの処理を書いてください。

`@property(copy, nonatomic) NSString *(^headerTitleForSectionObject)(id sectionObject);`

各セクションのヘッダーのタイトルを決めるブロック。

#### FRCAgentViewOject
	
NSFetchedResultController用のAgentViewObjectです。NSFetchedResultControllerが変更を反映する機能を提供しています。

#### AVOMergeSections

複数のAgentViewObjectを一つのAgentViewObjectとして扱うためのクラスです。

#### AVOAddtionalSection

追加用のCellを作るためのAgentViewObjectです。編集時に表示、非表示を行う機能があります。`editingInsertViewObject`に選択された際の挙動をBlocksで設定することができます。



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