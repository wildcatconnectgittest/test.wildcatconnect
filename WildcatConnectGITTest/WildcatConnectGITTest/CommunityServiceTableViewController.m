//
//  CommunityServiceTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "CommunityServiceTableViewController.h"
#import "CommunityServiceStructure.h"
#import "AppManager.h"
@interface CommunityServiceTableViewController ()

@end

@implementation CommunityServiceTableViewController{
    UIActivityIndicatorView *activity;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
    
    UIRefreshControl *refreshControl= [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl= refreshControl;
     
     if (self.loadNumber == [NSNumber numberWithInt:1] || ! self.loadNumber) {
          [self refreshData];
     } else {
          [self getPreviousNewCommunityServiceStructuresWithCompletion:^(NSMutableArray *returnArray) {
               self.newOpps = returnArray;
               [self getPreviousOldCommunityServiceStructuresWithCompletion:^(NSMutableArray *returnArrayB) {
                    self.oldOpps = returnArrayB;
                    self.allOpps = [[self.newOpps arrayByAddingObjectsFromArray:self.oldOpps] mutableCopy];
                    dispatch_async(dispatch_get_main_queue(), ^ {
                         [self.tableView reloadData];
                         [self refreshControl];
                    });
                }];
          }];
     }
}

-(void)refresh {
    [self refreshData];
    }

- (void)refreshData {
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButtonItem;
     [activity startAnimating];
     [barButtonItem release];
     [self testMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayA) {
          if (error) {
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Error fetching data from server. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
               [alertView show];
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [activity stopAnimating];
                    [self.tableView reloadData];
                    [self refreshControl];
                    [self.refreshControl endRefreshing];
               });
          } else {
               self.allOpps = returnArrayA;
               [self testMethodThreeWithCompletion:^(NSMutableArray *returnArrayB, NSMutableArray *returnArray2) {
                    self.newOpps = returnArray2;
                    self.oldOpps = returnArrayB;
                    NSMutableArray *itemsToSave = [NSMutableArray array];
                    for (CommunityServiceStructure *c in returnArray2) {
                         [itemsToSave addObject:@{ @"commTitleString"     : c.commTitleString, @"commSummaryString" : c.commSummaryString, @"IsNewNumber" : c.IsNewNumber, @"communityServiceID"  : c.communityServiceID, @"startDate" : c.startDate , @"endDate" : c.endDate
                                                   }];
                    }
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:itemsToSave forKey:@"newCommServiceItems"];
                    itemsToSave = [NSMutableArray array];
                    for (CommunityServiceStructure *c in returnArrayB) {
                         [itemsToSave addObject:@{ @"commTitleString"     : c.commTitleString, @"commSummaryString" : c.commSummaryString, @"IsNewNumber" : c.IsNewNumber, @"communityServiceID"  : c.communityServiceID, @"startDate" : c.startDate , @"endDate" : c.endDate
                                                   }];
                    }
                    [userDefaults setObject:itemsToSave forKey:@"oldCommServiceItems"];
                    dispatch_async(dispatch_get_main_queue(), ^ {
                         [activity stopAnimating];
                         [self.tableView reloadData];
                         [self.refreshControl endRefreshing];
                    });
               } withArray:returnArrayA];
          }
     }];
}

- (void)getPreviousOldCommunityServiceStructuresWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     CommunityServiceStructure *CSStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldCommServiceItems"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          object = theArrayToSearch[i];
          CSStructure = [[CommunityServiceStructure alloc] init];
          CSStructure.commTitleString = [object objectForKey:@"commTitleString"];
          CSStructure.commSummaryString = [object objectForKey:@"commSummaryString"];
          CSStructure.IsNewNumber = [object objectForKey:@"IsNewNumber"];
          CSStructure.communityServiceID = [object objectForKey:@"communityServiceID"];
          CSStructure.startDate = [object objectForKey:@"startDate"];
          CSStructure.endDate = [object objectForKey:@"endDate"];
          [array addObject:CSStructure];
          if (i == theArrayToSearch.count - 1)
               dispatch_group_leave(serviceGroup);
     }
     if (theArrayToSearch.count == 0) {
          dispatch_group_leave(serviceGroup);
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(array);
     });
}

- (void)getPreviousNewCommunityServiceStructuresWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     CommunityServiceStructure *CSStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"newCommServiceItems"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          object = theArrayToSearch[i];
          CSStructure = [[CommunityServiceStructure alloc] init];
          CSStructure.commTitleString = [object objectForKey:@"commTitleString"];
          CSStructure.commSummaryString = [object objectForKey:@"commSummaryString"];
          CSStructure.IsNewNumber = [object objectForKey:@"IsNewNumber"];
          CSStructure.communityServiceID = [object objectForKey:@"communityServiceID"];
          CSStructure.startDate = [object objectForKey:@"startDate"];
          CSStructure.endDate = [object objectForKey:@"endDate"];
          [array addObject:CSStructure];
          if (i == theArrayToSearch.count - 1)
               dispatch_group_leave(serviceGroup);
     }
     if (theArrayToSearch.count == 0) {
          dispatch_group_leave(serviceGroup);
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(array);
     });
}

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber {
     [super init];
     self.loadNumber = theLoadNumber;
     self.navigationItem.title = @"Community Service";
     return self;
}

- (void)testMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion {
    //Define errors to be processed when everything is complete.
    //One error per service; in this example we'll have two
    __block NSError *firstError = nil;
    //Create the dispatch group
    dispatch_group_t serviceGroup = dispatch_group_create();
    //Start the first service
    dispatch_group_enter(serviceGroup);
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    PFQuery *query = [CommunityServiceStructure query];
    [query orderByDescending:@"communityServiceID"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [returnArray addObjectsFromArray:objects];
        firstError = error;
        dispatch_group_leave(serviceGroup);
    }];
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        NSError *overallError = nil;
        if (firstError)
            overallError = firstError;
        completion(overallError, returnArray);
    });
}





- (void)testMethodTwoWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion withArray:(NSMutableArray *)array {
    /*CommunityServiceStructure *commServiceStructure;
     for (int i = 0; i < upcomingOpps.count; i++) {
     commServiceStructure = (CommunityServiceStructure *)[upcomingOpps objectAtIndex:i];
     PFFile *file = commServiceStructure.imageFile;
     NSData *data = [file getData];
     UIImage *image = [UIImage imageWithData:data];
     image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
     [self.commmImages addObject:image];
     }*/
    __block NSError *theError = nil;
    dispatch_group_t theServiceGroup = dispatch_group_create();
    dispatch_group_enter(theServiceGroup);
    CommunityServiceStructure *commServiceStructure;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        commServiceStructure = (CommunityServiceStructure *)[array objectAtIndex:i];
        /*if (commServiceStructure.hasImage == [NSNumber numberWithInt:1]) {
         PFFile *file = newsArticleStructure.imageFile;
         [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
         UIImage *image = [UIImage imageWithData:data];
         image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
         [returnArray addObject:image];
         if (i == array.count - 1)
         dispatch_group_leave(theServiceGroup);
         }];
         }
         else {
         [returnArray addObject:[[NSObject alloc] init]];
         if (i == array.count - 1)
         dispatch_group_leave(theServiceGroup);
         }*/
    }
    dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^{
        NSError *overallError = nil;
        if (theError)
            overallError = theError;
        completion(overallError, returnArray);
    });
}



- (void)testMethodThreeWithCompletion:(void (^)(NSMutableArray *returnArray, NSMutableArray *returnArray2))completion withArray:(NSMutableArray *)theArray {
    __block NSError *theError = nil;
    dispatch_group_t theServiceGroup = dispatch_group_create();
    dispatch_group_enter(theServiceGroup);
    CommunityServiceStructure *commServiceStructure;
    NSMutableArray *returnArray =[[NSMutableArray alloc]init];//old
    NSMutableArray *returnArray2 =[[NSMutableArray alloc]init];//new
     NSMutableArray *array = [theArray mutableCopy];
    for(int a = 0; a < array.count; a++ )
    {
        commServiceStructure = (CommunityServiceStructure *)[array objectAtIndex:a];
         NSInteger *integer = [commServiceStructure.IsNewNumber integerValue];
        if(integer == 0)
        {
            [returnArray addObject:commServiceStructure];
        }
        else if (integer == 1) {
            [returnArray2 addObject:commServiceStructure];
        }
        if (a == array.count -1)
            dispatch_group_leave(theServiceGroup);
    }
    dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^{
        NSError *overallError = nil;
        if (theError)
            overallError = theError;
        completion(returnArray, returnArray2);
    });
}


/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;}
 
 */




/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
 */


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    if (self.allOpps.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        cell.textLabel.text = @"No data to display.";
        return  cell;
    } else {
        if (indexPath.section == 0) {
             if (self.newOpps.count == 0) {
                  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
                  cell.textLabel.text = @"No data to display.";
                  return  cell;
             } else {
                  CommunityServiceStructure *commServiceStructure = ((CommunityServiceStructure *)[self.newOpps objectAtIndex:indexPath.row]);
                  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
                  cell.textLabel.text = commServiceStructure.commTitleString;
                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                  [dateFormatter setDateFormat:@"MM-dd-yyyy @ hh:mm a"];
                  NSString *startString = [dateFormatter stringFromDate:commServiceStructure.startDate];
                  NSString *endString = [dateFormatter stringFromDate:commServiceStructure.endDate];
                  cell.detailTextLabel.text = [[[[commServiceStructure.commSummaryString stringByAppendingString:@" ... STARTS "] stringByAppendingString:startString] stringByAppendingString:@" ... ENDS "] stringByAppendingString:endString];
                  cell.detailTextLabel.numberOfLines = 5;
                  return cell;
             }
        } else if (indexPath.section == 1) {
             if (self.oldOpps.count == 0) {
                  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
                  cell.textLabel.text = @"No data to display.";
                  return  cell;
             } else {
                  CommunityServiceStructure *commServiceStructure = ((CommunityServiceStructure *)[self.oldOpps objectAtIndex:indexPath.row]);
                  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
                  cell.textLabel.text = commServiceStructure.commTitleString;
                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                  [dateFormatter setDateFormat:@"MM-dd-yyyy @ hh:mm"];
                  NSString *startString = [dateFormatter stringFromDate:commServiceStructure.startDate];
                  NSString *endString = [dateFormatter stringFromDate:commServiceStructure.endDate];
                  cell.detailTextLabel.text = [[[[commServiceStructure.commSummaryString stringByAppendingString:@" ... STARTS "] stringByAppendingString:startString] stringByAppendingString:@" ... ENDS "] stringByAppendingString:endString];
                  cell.detailTextLabel.numberOfLines = 5;
                  return cell;
             }
        }
        else return nil;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.allOpps.count == 0)
        return @"";
    else {
        if (section == 0)
            return @"NEW OPPORTUNITIES";
        else if (section == 1)
            return @"OLD OPPORTUNITIES";
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.allOpps.count == 0)
        return 1;
    else {
        if (section == 0)
            return (self.newOpps.count == 0) ? 1 : self.newOpps.count;
        else if (section == 1)
            return (self.oldOpps.count == 0) ? 1 : self.oldOpps.count;
        return nil;
    }
    return nil;
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        if (self.updateOpps.count == 0) {
            return 1;
        } else
            return self.updateOpps.count;
    } else if (section == 1) {
        if (self.allOpps.count == 0) {
            return 1;
        } else
            return self.allOpps.count;
    }
    else return nil;
}*/


#pragma mark Table View Data Sources Methods;

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
