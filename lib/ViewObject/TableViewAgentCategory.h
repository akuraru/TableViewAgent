//
//  TableViewAgentCategory.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/10/13.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewAgent.h"

@interface TableViewAgent (AgentViewObject)

- (void)deleteCell:(NSIndexPath *)indexPath;
- (void)deleteCellsAtSection:(NSInteger)section rows:(NSArray *)rows;
- (void)insertCell:(NSIndexPath *)indexPath;
- (void)insertCellsAtSection:(NSInteger)section rows:(NSArray *)rows;
- (void)changeUpdateCell:(NSIndexPath *)indexPath;
- (void)changeMoveCell:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end
