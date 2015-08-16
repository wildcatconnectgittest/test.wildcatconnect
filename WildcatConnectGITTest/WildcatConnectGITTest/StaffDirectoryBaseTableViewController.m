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

- (UITableViewCell *)configureCell:(UITableViewCell *)cell forStaffMemberStructure:(StaffMemberStructure *)staffMemberStructure {
     cell.textLabel.text = [staffMemberStructure fullNameCommaString];
     NSString *string = staffMemberStructure.staffMemberTitle;
     cell.detailTextLabel.text = string;
     NSLog(@"%@", staffMemberStructure.staffMemberTitle);
     NSLog(@"%@", cell.detailTextLabel.text);
     [cell setNeedsLayout];
     return cell;
}

+ (NSString*) kCellIdentifierString {
     return kCellIdentifier;
}

@end
