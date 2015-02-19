//
//  SectionView.m
//  TableViewAgent
//
//  Created by akuraru on 2015/02/18.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewAgentSectionViewDelegate.h"
#import "ViewObject.h"

@interface SectionView : UITableViewHeaderFooterView <TableViewAgentSectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SectionView

+ (CGFloat)heightFromSectionObject:(id)o {
    return 20;
}
- (void)setSectionObject:(id)o {
    if ([o isKindOfClass:[NSArray class]]) {
        o = o[0];
    }
    if ([o isKindOfClass:[ViewObject class]]) {
        self.label.text = [o title];
    } else {
        self.label.text = [o name];
    }
}

@end