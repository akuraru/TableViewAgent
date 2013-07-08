//
// Created by P.I.akura on 2013/06/21.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol didSelectCell <NSObject>
@optional
- (void)didSelectCell:(id)viewObject;
@end
@protocol deleteCell <NSObject>
@optional
- (void)deleteCell:(id)viewObject;
@end
@protocol didSelectAdditionalCell <NSObject>
@optional
- (void)didSelectAdditionalCell;
@end
@protocol cellIdentifier <NSObject>
- (NSString *)cellIdentifier:(id)viewObject;
@end
@protocol viewForHeaderView <NSObject>
@optional
- (UIView *)viewForHeaderView:(id)viewObjects;
@end

@protocol TableViewAgentDelegate <didSelectCell, deleteCell, didSelectAdditionalCell, cellIdentifier>
@end

@protocol MSTableViewAgentDelegate <TableViewAgentDelegate, viewForHeaderView>
@end
