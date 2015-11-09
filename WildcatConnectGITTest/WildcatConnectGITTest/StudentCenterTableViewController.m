//
//  StudentCenterTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "StudentCenterTableViewController.h"
#import <Parse/Parse.h>
#import "PollStructure.h"
#import "PollDetailViewController.h"

@interface StudentCenterTableViewController ()

@end

@implementation StudentCenterTableViewController {
     UIActivityIndicatorView *activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
     UIRefreshControl *refreshControl= [[UIRefreshControl alloc] init];
     [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
     self.refreshControl= refreshControl;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     
     self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
     
     if (self.loadNumber == [NSNumber numberWithInt:1] || ! self.loadNumber) {
          [self refreshData];
     } else {
          activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
          [activity setBackgroundColor:[UIColor clearColor]];
          [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
          UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
          self.navigationItem.rightBarButtonItem = barButtonItem;
          [activity startAnimating];
          [barButtonItem release];
          [self getOldPollsMethodWithCompletion:^(NSMutableArray *returnArray) {
               self.pollArray = returnArray;
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [self.tableView reloadData];
                    [activity stopAnimating];
                    [self refreshControl];
                    [self.refreshControl endRefreshing];
               });
          }];
     }
}

- (void)refreshData {
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButtonItem;
     [activity startAnimating];
     [barButtonItem release];
     [self getNewPollsMethodWithCompletion:^(NSError *error, NSMutableArray *returnArray) {
          self.pollArray = returnArray;
          NSMutableArray *itemsToSave = [NSMutableArray array];
          for (PollStructure *p in returnArray) {
               [itemsToSave addObject:@{ @"pollTitle" : p.pollTitle, @"pollQuestion" : p.pollQuestion, @"pollType" : p.pollType, @"pollMultipleChoices" : p.pollMultipleChoices, @"pollID" : p.pollID }];
          }
          [[NSUserDefaults standardUserDefaults] setObject:itemsToSave forKey:@"pollStructures"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          dispatch_async(dispatch_get_main_queue(), ^ {
               [activity stopAnimating];
               [self.tableView reloadData];
               [self refreshControl];
               [self.refreshControl endRefreshing];
          });
     }];
}

- (void)viewDidDisappear:(BOOL)animated {
     [super viewDidDisappear:animated];
     NSMutableArray *itemsToSave = [NSMutableArray array];
     for (PollStructure *p in self.pollArray) {
          [itemsToSave addObject:@{ @"pollTitle" : p.pollTitle, @"pollQuestion" : p.pollQuestion, @"pollType" : p.pollType, @"pollMultipleChoices" : p.pollMultipleChoices, @"pollID" : p.pollID }];
     }
     [[NSUserDefaults standardUserDefaults] setObject:itemsToSave forKey:@"pollStructures"];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

/*- (void)removeOldArrayObjectsWithCompletion:(void (^)(NSUInteger integer))completion withArray:(NSMutableArray *)array {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     NSMutableArray *theArray = [array mutableCopy];
     NSMutableArray *dictionaryArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"];
     NSMutableArray *searchDictionaryArray = [dictionaryArray mutableCopy];
     NSMutableArray *likedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"likedNewsArticles"];
     NSMutableArray *likesDictionaryArray = [likedArray mutableCopy];
     if (searchDictionaryArray.count > theArray.count) {
               //Have some objects to remove...
          for (int i = 0; i < searchDictionaryArray.count; i++) {
               NSNumber *number = (NSNumber *)[searchDictionaryArray objectAtIndex:i];
               BOOL contained = false;
               for (NewsArticleStructure *structure in theArray) {
                    if (structure.articleID == number) {
                         contained = true;
                         break;
                    }
               }
               if (! contained) {
                    [searchDictionaryArray removeObjectAtIndex:i];
               }
          }
          [[NSUserDefaults standardUserDefaults] setObject:searchDictionaryArray forKey:@"readNewsArticles"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          dispatch_group_leave(serviceGroup);
     }
     else {
               //Have some objects to remove...
          for (int i = 0; i < likesDictionaryArray.count; i++) {
               NSNumber *number = (NSNumber *)[likesDictionaryArray objectAtIndex:i];
               BOOL contained = false;
               for (NewsArticleStructure *structure in theArray) {
                    if (structure.articleID == number) {
                         contained = true;
                         break;
                    }
               }
               if (! contained) {
                    [likesDictionaryArray removeObjectAtIndex:i];
               }
          }
          [[NSUserDefaults standardUserDefaults] setObject:likesDictionaryArray forKey:@"likedNewsArticles"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          dispatch_group_leave(serviceGroup);
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(0);
     });
}*/

- (void)getOldPollsMethodWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
          //Start the first service
     dispatch_group_enter(serviceGroup);
     PollStructure *pollStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"pollStructures"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          object = theArrayToSearch[i];
          pollStructure = [[PollStructure alloc] init];
          pollStructure.pollTitle = [object objectForKey:@"pollTitle"];
          pollStructure.pollQuestion = [object objectForKey:@"pollQuestion"];
          pollStructure.pollType = [object objectForKey:@"pollType"];
          pollStructure.pollMultipleChoices = [object objectForKey:@"pollMultipleChoices"];
          pollStructure.pollID = [object objectForKey:@"pollID"];
          [array addObject:pollStructure];
          if (i == theArrayToSearch.count - 1) {
               dispatch_group_leave(serviceGroup);
          }
     }
     if (theArrayToSearch.count == 0) {
          dispatch_group_leave(serviceGroup);
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(array);
     });
}

- (void)getNewPollsMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion {
     __block NSError *firstError = nil;
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     PFQuery *query = [PollStructure query];
     [query orderByDescending:@"pollID"];
     query.limit = 5;
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          [returnArray addObjectsFromArray:objects];
          firstError = error;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          NSError *overallError = nil;
          if (firstError) {
               overallError = firstError;
          }
          completion(overallError, returnArray);
     });
}

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber {
     [super init];
     self.loadNumber = theLoadNumber;
     self.navigationItem.title = @"Student Center";
     return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (self.pollArray.count == 0) {
          return 1;
     } else return self.pollArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    
     if (self.pollArray.count == 0) {
          cell.textLabel.text = @"No data to display.";
     } else {
          PollStructure *pollStructure = (PollStructure *)[self.pollArray objectAtIndex:indexPath.row];
          cell.textLabel.text = pollStructure.pollTitle;
          cell.textLabel.numberOfLines = 0;
          cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
          cell.detailTextLabel.text = pollStructure.pollQuestion;
          cell.detailTextLabel.numberOfLines = 4;
          if (! [self.answeredPolls containsObject:pollStructure.pollID]) {
               UIButton *unreadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
               [unreadButton setImage:[UIImage imageNamed:@"unread@2x.png"] forState:UIControlStateNormal];
               [unreadButton setEnabled:NO];
               [unreadButton sizeToFit];
               cell.accessoryView = unreadButton;
               [cell setNeedsLayout];
          }
     }
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     NSMutableArray *readArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"answeredPolls"];
     if (! readArray) {
          self.answeredPolls = [NSMutableArray array];
     } else
          self.answeredPolls = [readArray mutableCopy];
     [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     self.selectedPollStructure = self.pollArray[indexPath.row];
     PollDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PollDetail"];
     controller.pollStructure = self.selectedPollStructure;
     [self.navigationController pushViewController:controller animated:YES];
     NSMutableArray *theAnsweredPolls = [[NSUserDefaults standardUserDefaults] objectForKey:@"answeredPolls"];
     if (! theAnsweredPolls) {
          theAnsweredPolls = [[NSMutableArray alloc] init];
     }
     if (! [theAnsweredPolls containsObject:self.selectedPollStructure.pollID]) {
          [theAnsweredPolls addObject:self.selectedPollStructure.pollID];
          [[NSUserDefaults standardUserDefaults] setObject:theAnsweredPolls forKey:@"answeredPolls"];
          [[NSUserDefaults standardUserDefaults] synchronize];
     }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     return @"CURRENT POLLS";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
