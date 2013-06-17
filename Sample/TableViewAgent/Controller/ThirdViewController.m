//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ThirdViewController.h"
#import "ViewObject.h"


@implementation ThirdViewController {
    ViewObject *viewObject;
}
- (void)setViewObject:(ViewObject *)vo {
    viewObject = vo;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleText.text = viewObject.title;
    self.messageText.text = viewObject.message;
}

- (IBAction)touchSave:(id)sender {
    viewObject.title = self.titleText.text;
    viewObject.message = self.messageText.text;

    if ([self.delegate respondsToSelector:@selector(saveViewObject:)]) {
        [self.delegate saveViewObject:viewObject];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end