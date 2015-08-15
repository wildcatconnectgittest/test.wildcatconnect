//
//  StaffDirectoryBaseTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/14/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StaffMemberStructure;

@interface StaffDirectoryBaseTableViewController : UITableViewController

- (void)configureCell:(UITableViewCell *)cell forStaffMemberStructure:(StaffMemberStructure *)staffMemberStructure;

+ (NSString *)kCellIdentifierString;

@end
