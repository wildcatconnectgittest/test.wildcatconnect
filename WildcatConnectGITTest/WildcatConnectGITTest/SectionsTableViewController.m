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
     
     self.sectionsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"News Center", @"Extracurriculars", @"Community Service", @"Student Center", @"Calendar", @"Lunch Menus", @"Useful Links", @"Staff Directory", nil]];
     self.segueIDsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"showNewsCenter", @"showExtracurriculars", @"showCommunityService", @"showStudentCenter", @"showCalendar", @"showLunchMenus", @"showUsefulLinks", @"showStaffDirectory", nil]];
     self.sectionsImagesArray = [[NSMutableArray alloc] init];
     [self.sectionsImagesArray addObject:@"theNews@2x.png"];
     [self.sectionsImagesArray addObject:@"extracurriculars@2x.png"];
     [self.sectionsImagesArray addObject:@"communityService@2x.png"];
     [self.sectionsImagesArray addObject:@"studentCenter@2x.png"];
     [self.sectionsImagesArray addObject:@"calendar@2x.png"];
     [self.sectionsImagesArray addObject:@"lunchMenus@2x.png"];
     [self.sectionsImagesArray addObject:@"usefulLinks@2x.png"];
     [self.sectionsImagesArray addObject:@"staffDirectory@2x.png"];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
          //Load the sectionsNumbersArray
     NSMutableArray *numbersArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"sectionsNumbersArray"];
     if (numbersArray) {
          self.sectionsNumbersArray = numbersArray;
     }
     else {
               //Create new array
          self.sectionsNumbersArray = [self createNewNumbersArray];
     }
     NSMutableArray *readNewsArticlesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticlesArray"];
     if (! readNewsArticlesArray) {
          readNewsArticlesArray = [[NSMutableArray alloc] init];
     }
     NSMutableArray *readECArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readECArray"];
     if (! readECArray) {
          readECArray = [[NSMutableArray alloc] init];
     }
     NSMutableArray *readCommArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readCommArray"];
     if (! readCommArray) {
          readCommArray = [[NSMutableArray alloc] init];
     }
     NSMutableArray *updatingArray = [self.sectionsNumbersArray mutableCopy];
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButton;
     [activity startAnimating];
     [self updateSectionNumbersOneWithCompletion:^(NSError *error, NSNumber *numberOne) {
          [updatingArray setObject:numberOne atIndexedSubscript:[[NSNumber numberWithInt:0] integerValue]];
          [self updateSectionNumbersTwoWithCompletion:^(NSError *error, NSNumber *numberTwo) {
               [updatingArray setObject:numberTwo atIndexedSubscript:[[NSNumber numberWithInt:1] integerValue]];
               [self updateSectionNumbersThreeWithCompletion:^(NSError *error, NSNumber *numberThree) {
                    [updatingArray setObject:numberThree atIndexedSubscript:[[NSNumber numberWithInt:2] integerValue]];
                    [activity stopAnimating];
                    self.sectionsNumbersArray = updatingArray;
                    [self.tableView reloadData];
               } withArray:readCommArray];
          } withArray:readECArray];
     } withArray:readNewsArticlesArray];
}

- (void)updateSectionNumbersOneWithCompletion:(void (^) (NSError *error, NSNumber *numberOne))completion withArray:(NSMutableArray *)array {
     __block NSError *theError = nil;
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
          //One = News (get)
     __block NSNumber *returnNumber = [[NSNumber alloc] init];
     PFQuery *query = [NewsArticleStructure query];
     [query whereKey:@"articleID" notContainedIn:array];
     [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
          returnNumber = [NSNumber numberWithInt:number];
          dispatch_group_leave(serviceGroup);
          theError = error;
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(theError, returnNumber);
     });
}

- (void)updateSectionNumbersTwoWithCompletion:(void (^) (NSError *error, NSNumber *numberTwo))completion withArray:(NSMutableArray *)array {
     __block NSError *theError = nil;
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
          //One = News (get)
     __block NSNumber *returnNumber = [[NSNumber alloc] init];
     PFQuery *query = [ExtracurricularStructure query];
     [query whereKey:@"extracurricularID" notContainedIn:array];
     [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
          returnNumber = [NSNumber numberWithInt:number];
          dispatch_group_leave(serviceGroup);
          theError = error;
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(theError, returnNumber);
     });
}

- (void)updateSectionNumbersThreeWithCompletion:(void (^) (NSError *error, NSNumber *numberThree))completion withArray:(NSMutableArray *)array {
     __block NSError *theError = nil;
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
          //One = News (get)
     __block NSNumber *returnNumber = [[NSNumber alloc] init];
     PFQuery *query = [CommunityServiceStructure query];
     [query whereKey:@"communityServiceID" notContainedIn:array];
     [query whereKey:@"IsNewNumber" equalTo:[NSNumber numberWithInt:1]];
     [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
          returnNumber = [NSNumber numberWithInt:number];
          dispatch_group_leave(serviceGroup);
          theError = error;
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(theError, returnNumber);
     });
}

- (void)viewWillDisappear:(BOOL)animated {
     [super viewWillDisappear:animated];
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults setObject:self.sectionsNumbersArray forKey:@"sectionsNumbersArray"];
     [userDefaults synchronize];
}

- (NSMutableArray *)createNewNumbersArray {
     NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     for (int i = 0; i < self.sectionsArray.count; i ++) {
          [returnArray addObject:[NSNumber numberWithInt:0]];
     }
     return returnArray;
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
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
     cell.textLabel.text = self.sectionsArray[indexPath.row];
     cell.imageView.image = [UIImage imageNamed:self.sectionsImagesArray[indexPath.row]];
     /*UIButton *button = [[UIButton alloc] init];
     button.titleLabel.text = @"Testing";
     cell.accessoryView = button;*/
          //cell.accessoryType = UITableViewCellAccessoryDetailButton;
     
     NSNumber *number = [self.sectionsNumbersArray objectAtIndex:indexPath.row];
     NSInteger integer = [number integerValue];
     if (integer != 0 && (indexPath.row == 0 ||indexPath.row == 1 || indexPath.row == 2)) {
          UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
          [downloadButton setTitle:[number stringValue] forState:UIControlStateNormal];
          [downloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
          downloadButton.enabled = false;
          [downloadButton sizeToFit];
          [downloadButton setFrame:CGRectMake(0, 0, downloadButton.frame.size.width, downloadButton.frame.size.height)];
          cell.accessoryView = downloadButton;
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
          //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
         // [self performSegueWithIdentifier:self.segueIDsArray[indexPath.row] sender:self];
     /*[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass:[MyClass class]]) {
      foundIndex = idx;
      // stop the enumeration
      *stop = YES;
      }
      }];*/
     
     /*NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableArray *visitedPagesArray = [userDefaults objectForKey:@"visitedPagesArray"];
     if (!visitedPagesArray) {
          visitedPagesArray = [[NSMutableArray alloc] init];
          [visitedPagesArray addObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]];
          [userDefaults setObject:visitedPagesArray forKey:@"visitedPagesArray"];
          [userDefaults synchronize];
          if (indexPath.row == 0) {
               NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
               [self.navigationController pushViewController:controller animated:YES];
          }
     }
     else {
          if ([visitedPagesArray containsObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]]) {
               if (indexPath.row == 0) {
                    NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:0]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
          }
          else {
               if (indexPath.row == 0) {
                    NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
          }
      }*/NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
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
          }
     }

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     /*NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableArray *array = [[NSMutableArray alloc] init];
     array = [userDefaults objectForKey:@"visitedSectionsArray"];
     if ([array containsObject:segue.identifier]) {
          if ([segue.identifier isEqualToString:@"showNewsCenter"]) {
               NewsCenterTableViewController *controller = (NewsCenterTableViewController *)segue.destinationViewController;
               controller.loadNumber = [NSNumber numberWithInt:1];
               NSMutableArray *newsArticlesArray = [userDefaults objectForKey:@"newsArticles"];
               if (newsArticlesArray)
                    controller.newsArticles = newsArticlesArray;
               NSMutableArray *newsImagesArray = [userDefaults objectForKey:@"newsArticleImages"];
               if (newsImagesArray)
                    controller.newsArticleImages = newsImagesArray;
          }
     } else {
          if (! array) {
               array = [[NSMutableArray alloc] init];
          }
          [array addObject:segue.identifier];
          [userDefaults setObject:array forKey:@"visitedSectionsArray"];
          [userDefaults synchronize];
     }*/
}


@end
