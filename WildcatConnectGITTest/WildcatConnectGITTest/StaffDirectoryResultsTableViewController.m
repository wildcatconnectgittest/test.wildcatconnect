//
//  StaffDirectoryResultsTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/14/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "StaffDirectoryResultsTableViewController.h"
#import "StaffMemberStructure.h"

@implementation StaffDirectoryResultsTableViewController

@synthesize filteredStaffMembers;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.filteredStaffMembers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
          // Return the number of sections.
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cellID"];
     StaffMemberStructure *staffMemberStructure = self.filteredStaffMembers[indexPath.row];
     if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
               // More initializations if needed.
     }
     [self configureCell:cell forStaffMemberStructure:staffMemberStructure];
     return cell;
}

@end
