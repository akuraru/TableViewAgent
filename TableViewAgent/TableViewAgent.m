//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TableViewAgent.h"
#import "TableViewAgentCellDelegate.h"

@implementation TableViewAgent

- (void)setCellId:(NSString *)c {
    cellId = c;
}
- (void)setViewObjects:(id)v {
    viewObjects = v;
}

- (void)setDelegate:(id)d {
    delegate = d;
    [[d tableView] setDelegate:self];
    [[d tableView] setDataSource:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<TableViewAgentCellDelegate>cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell setViewObject:[self viewObjectWithIndex:indexPath]];
    return cell;
}

- (id)viewObjectWithIndex:(NSIndexPath *)path {
    return viewObjects[path.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end