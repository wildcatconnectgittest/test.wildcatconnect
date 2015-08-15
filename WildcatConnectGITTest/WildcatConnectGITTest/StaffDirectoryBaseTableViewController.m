//
//  StaffDirectoryBaseTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/14/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "StaffDirectoryBaseTableViewController.h"
#import "StaffMemberStructure.h"

NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"TableCell";

@implementation StaffDirectoryBaseTableViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

- (void)configureCell:(UITableViewCell *)cell forStaffMemberStructure:(StaffMemberStructure *)staffMemberStructure {
     cell.textLabel.text = [staffMemberStructure fullNameCommaString];
     cell.detailTextLabel.text = staffMemberStructure.staffMemberTitle;
}

+ (NSString*) kCellIdentifierString {
     return kCellIdentifier;
}

@end
