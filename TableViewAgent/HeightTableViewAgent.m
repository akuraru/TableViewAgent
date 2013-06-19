//
//  HeightTableViewCell.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "HeightTableViewAgent.h"

@implementation HeightTableViewAgent

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [[delegate tableView] dequeueReusableCellWithIdentifier:cellId];
    if ([cell respondsToSelector:@selector(heightFromViewObject:)]) {
        return [cell heightFromViewObject:[self viewObjectWithIndex:indexPath]];
    } else {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
}

@end
