//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class ViewObject;

@protocol ThirdViewControllerDelegate
- (void)saveViewObject:(id)viewObject;
@end

@interface ThirdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *messageText;

@property (weak, nonatomic) id delegate;

- (IBAction)touchSave:(id)sender;

- (void)setViewObject:(ViewObject *)viewObject;

@end