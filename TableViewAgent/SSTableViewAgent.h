//
//  SSTableViewAgent.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "TableViewAgent.h"

@interface SSTableViewAgent : TableViewAgent

- (void)setAdditionalCellId:(NSString *)aci;

- (void)setEditing:(BOOL)b;

- (BOOL)editing;

- (void)addViewObject:(id)object;

@end
