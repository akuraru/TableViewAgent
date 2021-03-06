//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AVOSingleRow.h"
#import "TableViewAgentProtocol.h"

@implementation AVOSingleRow

- (id)initWithViewObject:(id)viewObject {
    self = [super init];
    if (self) {
        self.viewObject = viewObject;
    }
    return self;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    if ([self.viewObject isEqual:object]) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return nil;
}

- (NSUInteger)countInSection:(NSUInteger)section {
    return 1;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.convert ? self.convert(self.viewObject) : self.viewObject;
}

- (id)sectionObjectInSection:(NSInteger)section {
    return self.viewObject;
}

- (NSUInteger)sectionCount {
    return 1;
}

- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)canEdit {
    return NO;
}

- (void)setEditing:(BOOL)editing {
}

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)path {
    return UITableViewCellEditingStyleNone;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellIdentifier([self objectAtIndexPath:indexPath]);
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCell) {
        self.didSelectCell([self objectAtIndexPath:indexPath]);
    }
}

- (UIColor *)cellBackgroundColor:(NSIndexPath *)indexPath {
    if (self.cellBackgroundColorForObject) {
        self.cellBackgroundColorForObject([self objectAtIndexPath:indexPath]);
    }
    return nil;
}

- (UIColor *)headerViewBackgroundColor:(NSInteger)section {
    if (self.headerViewBackgroundColorForSectionObject) {
        self.headerViewBackgroundColorForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (UIColor *)footerViewBackgroundColor:(NSInteger)section {
    if (self.footerViewBackgroundColorForSectionObject) {
        self.footerViewBackgroundColorForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    if (self.headerTitleForSectionObject) {
        return self.headerTitleForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    if (self.footerTitleForSectionObject) {
        return self.footerTitleForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)headerIdentifierInSection:(NSInteger)section {
    if (self.headerIdentifierForSectionObject) {
        return self.headerIdentifierForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)footerIdentifierInSection:(NSInteger)section {
    if (self.footerIdentifierForSectionObject) {
        return self.footerIdentifierForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (BOOL)canDidSelectAccessoryButton:(NSIndexPath *)indexPath {
    return self.didSelectAccessoryButton != nil;
}

- (void)didSelectAccessoryButtonAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectAccessoryButton) {
        self.didSelectAccessoryButton([self objectAtIndexPath:indexPath]);
    }
}

- (void)editingDeleteForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editingDeleteViewObject) {
        self.editingDeleteViewObject([self objectAtIndexPath:indexPath]);
    }
}

- (void)editingInsertForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self editingInsertViewObject]) {
        self.editingInsertViewObject([self objectAtIndexPath:indexPath]);
    }
}
@end