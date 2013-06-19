//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SelectCellTableViewAgent.h"


@implementation SelectCellTableViewAgent {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([delegate respondsToSelector:@selector(didSelectCell:)]) {
        [delegate didSelectCell:[self viewObjectWithIndex:indexPath]];
    }
}

@end