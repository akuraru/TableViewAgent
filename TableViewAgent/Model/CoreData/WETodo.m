//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WETodo.h"
#import "Todo.h"


@implementation WETodo {

}

- (id)initWithTodo:(Todo *)todo {
    self = [super init];
    if (self) {
        _todo = todo;
        _title = todo.title;
        _message = todo.message;
    }
    return self;
}

- (void)update:(Todo *)todo {
    todo.title = _title;
    todo.message = _message;
}
@end