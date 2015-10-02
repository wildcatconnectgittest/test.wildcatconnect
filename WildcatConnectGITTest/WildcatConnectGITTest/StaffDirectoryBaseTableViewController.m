//
//  StaffDirectoryBaseTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/14/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "StaffDirectoryBaseTableViewController.h"
#import "StaffMemberStructure.h"
#import "EmailButton.h"

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
     cell.detailTextLabel.text = [[string stringByAppendingString:@" - "] stringByAppendingString: staffMemberStructure.staffMemberLocation];
     EmailButton *emailButton = [EmailButton buttonWithType:UIButtonTypeRoundedRect];
     [emailButton setImage:[UIImage imageNamed:@"email@2x.png"] forState:UIControlStateNormal];
     [emailButton setEnabled:YES];
     [emailButton sizeToFit];
     emailButton.staffMember = staffMemberStructure;
     [emailButton addTarget:self
                action:@selector(buttonTouchUpInside:)
      forControlEvents:UIControlEventTouchUpInside];
     [emailButton setFrame:CGRectMake(0, 0, emailButton.frame.size.width, emailButton.frame.size.height)];
     cell.accessoryView = emailButton;
     [cell setNeedsLayout];
     return cell;
}

- (IBAction) buttonTouchUpInside:(id)sender {
     EmailButton *buttonClicked = (EmailButton *)sender;
     NSString *theString = [@"mailto:" stringByAppendingString:buttonClicked.staffMember.staffMemberEMail];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theString]];
}

+ (NSString*) kCellIdentifierString {
     return kCellIdentifier;
}

@end
