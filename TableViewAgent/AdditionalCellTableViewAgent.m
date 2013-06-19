//
// Created by P.I.akura on 2013/06/17.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AdditionalCellTableViewAgent.h"


@implementation AdditionalCellTableViewAgent {
    NSString *additionalCellId;
}

- (void)setAdditionalCellId:(NSString *)aci {
    additionalCellId = aci;
}
- (void)addViewObject:(id)object {
    viewObjects = [viewObjects arrayByAddingObject:object];
    [self insertRowWithSection:0];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [self createAdditionalCell:tableView];
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:additionalCellId];;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        if ([delegate respondsToSelector:@selector(didSelectAdditionalCell)]) {
            [delegate didSelectAdditionalCell];
        }
    }
}

- (BOOL)isAdditionalCellOfIndexPath:(NSIndexPath *)path {
    return [viewObjects count] == path.row;
}
@end