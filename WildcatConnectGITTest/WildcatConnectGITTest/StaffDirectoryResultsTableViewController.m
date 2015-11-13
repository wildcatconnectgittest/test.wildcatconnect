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
     if (self.filteredStaffMembers.count == 0)
          return 1;
     return self.filteredStaffMembers.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
     return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
          // Return the number of sections.
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (self.filteredStaffMembers.count == 0) {
          UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:@"cellID"];
          cell.textLabel.text = @"No results.";
          return cell;
     }
     else {
          UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:@"cellID"];
          StaffMemberStructure *staffMemberStructure = self.filteredStaffMembers[indexPath.row];
          [self configureCell:cell forStaffMemberStructure:staffMemberStructure];
          return cell;
     }
}

@end
