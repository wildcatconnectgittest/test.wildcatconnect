//
//  SectionsTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "SectionsTableViewController.h"
#import "NewsCenterTableViewController.h"
#import "StaffDirectoryMainTableViewController.h"
#import "CommunityServiceTableViewController.h"
#import "ExtracurricularsTableViewController.h"
#import "UsefulLinksTableViewController.h"
#import "LunchMenusViewController.h"
#import "AdministrationLogInViewController.h"
#import "AdministrationMainTableViewController.h"
#import <Parse/Parse.h>
#import "NewsArticleStructure.h"
#import "ExtracurricularUpdateStructure.h"
#import "CommunityServiceStructure.h"

@interface SectionsTableViewController ()

@end

@implementation SectionsTableViewController {
     UIActivityIndicatorView *activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
     
     self.sectionsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"News Center", @"Extracurriculars", @"Community Service", @"Student Center", @"Calendar", @"Lunch Menus", @"Useful Links", @"Staff Directory", @"Administration", nil]];
     self.sectionsImagesArray = [[NSMutableArray alloc] init];
     [self.sectionsImagesArray addObject:@"theNews@2x.png"];
     [self.sectionsImagesArray addObject:@"extracurriculars@2x.png"];
     [self.sectionsImagesArray addObject:@"communityService@2x.png"];
     [self.sectionsImagesArray addObject:@"studentCenter@2x.png"];
     [self.sectionsImagesArray addObject:@"calendar@2x.png"];
     [self.sectionsImagesArray addObject:@"lunchMenus@2x.png"];
     [self.sectionsImagesArray addObject:@"usefulLinks@2x.png"];
     [self.sectionsImagesArray addObject:@"staffDirectory@2x.png"];
     [self.sectionsImagesArray addObject:@"admin@2x.png"];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     NSMutableArray *returnArray = [NSMutableArray array];
     NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
      self.navigationItem.rightBarButtonItem = barButton;
      [activity startAnimating];
     [self getCountMethodWithCompletion:^(NSInteger count) {
          NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"];
          NSInteger read = array.count;
          NSNumber *number = [NSNumber numberWithInt:(count - read)];
          [returnArray addObject:number];
          self.sectionsNumbersArray = returnArray;
          [activity stopAnimating];
          [self.tableView reloadData];
     }];
}

- (void)getCountMethodWithCompletion:(void (^)(NSInteger count))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFQuery *query = [NewsArticleStructure query];
     __block int count;
     [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
          count = number;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(count);
     });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.sectionsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
     cell.textLabel.text = self.sectionsArray[indexPath.row];
     cell.imageView.image = [UIImage imageNamed:self.sectionsImagesArray[indexPath.row]];
     if (indexPath.row == 0) {
          NSNumber *number = [self.sectionsNumbersArray objectAtIndex:indexPath.row];
          NSInteger integer = [number integerValue];
          if (integer != 0) {
               UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
               [downloadButton setTitle:[number stringValue] forState:UIControlStateNormal];
               [downloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
               downloadButton.enabled = false;
               [downloadButton sizeToFit];
               [downloadButton setFrame:CGRectMake(0, 0, downloadButton.frame.size.width, downloadButton.frame.size.height)];
               cell.accessoryView = downloadButton;
          }
          else if (integer == 0) {
               cell.accessoryView = nil;
          }
     } else if (indexPath.row == 8) {
          if ([PFUser currentUser]) {
               NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
               NSString *lastName = [[PFUser currentUser] objectForKey:@"lastName"];
               cell.detailTextLabel.text = [@"Logged in as " stringByAppendingString:[[firstName stringByAppendingString:@" "] stringByAppendingString:lastName]];
          }
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableArray *theVisitedPagesArray = [userDefaults objectForKey:@"visitedPagesArray"];
     NSMutableArray *visitedPagesArray = [[NSMutableArray alloc] init];
     [visitedPagesArray addObjectsFromArray:theVisitedPagesArray];
     if (! visitedPagesArray) {
          visitedPagesArray = [[NSMutableArray alloc] init];
          [visitedPagesArray addObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]];
          [userDefaults setObject:visitedPagesArray forKey:@"visitedPagesArray"];
          [userDefaults synchronize];
          if (indexPath.row == 0) {
                    NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                    [self.navigationController pushViewController:controller animated:YES];
          }
          else if (indexPath.row == 1) {
               ExtracurricularsTableViewController *controller = [[ExtracurricularsTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
               [self.navigationController pushViewController:controller animated:YES];
          }
          else if (indexPath.row == 2) {
               CommunityServiceTableViewController *controller = [[CommunityServiceTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
               [self.navigationController pushViewController:controller animated:YES];
          }
          else if (indexPath.row == 5) {
               LunchMenusViewController *controller = [[LunchMenusViewController alloc] initWithStyle:UITableViewStyleGrouped];
               [self.navigationController pushViewController:controller animated:YES];
          }
          else if (indexPath.row == 6) {
               UsefulLinksTableViewController *controller = [[UsefulLinksTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
               [self.navigationController pushViewController:controller animated:YES];
          }
          else if (indexPath.row == 7) {
               StaffDirectoryMainTableViewController *controller = [[StaffDirectoryMainTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
               [self.navigationController pushViewController:controller animated:YES];
          }
          else if (indexPath.row == 8) {
               if ([PFUser currentUser]) {
                    AdministrationMainTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainID"];
                    [self.navigationController pushViewController:controller animated:YES];
               } else {
                    AdministrationLogInViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInID"];
                    [self.navigationController pushViewController:controller animated:YES];
               }
          }
     }
     else {
          if ([visitedPagesArray containsObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]]) {
               if (indexPath.row == 0) {
                         NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:0]];
                         [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 1) {
                    ExtracurricularsTableViewController *controller = [[ExtracurricularsTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:0]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 2) {
                    CommunityServiceTableViewController *controller = [[CommunityServiceTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:0]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 5) {
                    LunchMenusViewController *controller = [[LunchMenusViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 6) {
                    UsefulLinksTableViewController *controller = [[UsefulLinksTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 7) {
                    StaffDirectoryMainTableViewController *controller = [[StaffDirectoryMainTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:0]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 8) {
                    if ([PFUser currentUser]) {
                         AdministrationMainTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainID"];
                         [self.navigationController pushViewController:controller animated:YES];
                    } else {
                         AdministrationLogInViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInID"];
                         [self.navigationController pushViewController:controller animated:YES];
                    }
               }
          }
          else {
               [visitedPagesArray addObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]];
               [userDefaults setObject:visitedPagesArray forKey:@"visitedPagesArray"];
               [userDefaults synchronize];
               if (indexPath.row == 0) {
                         NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                         [self.navigationController pushViewController:controller animated:YES];
               }else if (indexPath.row == 1) {
                    ExtracurricularsTableViewController *controller = [[ExtracurricularsTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                    [self.navigationController pushViewController:controller animated:YES];
               } else if (indexPath.row == 2) {
                    CommunityServiceTableViewController *controller = [[CommunityServiceTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 5) {
                    LunchMenusViewController *controller = [[LunchMenusViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 6) {
                    UsefulLinksTableViewController *controller = [[UsefulLinksTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 7) {
                    StaffDirectoryMainTableViewController *controller = [[StaffDirectoryMainTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
               else if (indexPath.row == 8) {
                    if ([PFUser currentUser]) {
                         AdministrationMainTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainID"];
                         [self.navigationController pushViewController:controller animated:YES];
                    } else {
                         AdministrationLogInViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInID"];
                         [self.navigationController pushViewController:controller animated:YES];
                    }
               }
          }
     }

}

@end
