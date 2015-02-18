//
//  SectionView.m
//  TableViewAgent
//
//  Created by akuraru on 2015/02/18.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewAgentSectionViewDelegate.h"

@interface SectionView : UITableViewHeaderFooterView <TableViewAgentSectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SectionView

+ (CGFloat)heightFromSectionObject:(id)o {
    return 20;
}
- (void)setSectionObject:(id)o {
    self.label.text = [o title];
}

@end