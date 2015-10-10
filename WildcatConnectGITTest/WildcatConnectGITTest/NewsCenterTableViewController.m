//
//  NewsCenterTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "NewsCenterTableViewController.h"
#import "AppManager.h"
#import "NewsArticleStructure.h"
#import "NewsArticleDetailViewController.h"

@implementation NewsCenterTableViewController {
     UIActivityIndicatorView *activity;
}

- (void)viewDidLoad {
     [super viewDidLoad];
    
    
    
    //NSMutableArray *articles =[[NSMutableArray alloc] initWithObjects:@ "1" , @"2", nil];
    //self.newsArticles = articles;
    UIRefreshControl *refreshControl= [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl= refreshControl;
          //self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:231 green:32 blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
    
     NSLog(@"%@", self.storyboard);
    
    
    if (self.loadNumber == [NSNumber numberWithInt:1] || ! self.loadNumber) {
               [self refreshData];
          }
          else {
               activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
               [activity setBackgroundColor:[UIColor clearColor]];
               [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
               UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
               self.navigationItem.rightBarButtonItem = barButton;
               [activity startAnimating];
               [self getOldDataWithCompletion:^(NSMutableArray *returnArray) {
                    self.newsArticles = returnArray;
                    [self getOldImagesWithCompletion:^(NSMutableArray *returnArrayB) {
                         self.newsArticleImages = returnArrayB;
                         dispatch_async(dispatch_get_main_queue(), ^ {
                              [self.tableView reloadData];
                              [activity stopAnimating];
                              //UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
                              //self.navigationItem.rightBarButtonItem = barButtonItem;
                              [self refreshControl];
                         });
                    }];
               }];
          }
}

- (void)refresh{
    [self refreshData];
    [self.refreshControl endRefreshing];
    
}


/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCenterTableViewController *selectednewsArticles = (tableView == self.tableView) ?
    self.newsArticles[indexPath.row] : self.resultsTableController.filteredProducts[indexPath.row];
    
    APLDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"APLDetailViewController"];
    detailViewController.product = selectedProduct; // hand off the current product to the detail view controller
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}*/



- (void)getOldImagesWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
          //Start the first service
     dispatch_group_enter(serviceGroup);
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"newsArticleImages"];
     NSData *data;
     UIImage *image;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          data = theArrayToSearch[i];
          image = [UIImage imageWithData:data];
          if (image) {
               [array addObject:image];
          }
          else
               [array addObject:[[NSObject alloc] init]];
          if (i == theArrayToSearch.count - 1) {
               dispatch_group_leave(serviceGroup);
          }
     }
     if (theArrayToSearch.count == 0) {
          dispatch_group_leave(serviceGroup);
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(array);
     });
}

- (void)getOldDataWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
          //Start the first service
     dispatch_group_enter(serviceGroup);
     NewsArticleStructure *newsArticleStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"newsArticles"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i ++) {
          object = theArrayToSearch[i];
          newsArticleStructure = [[NewsArticleStructure alloc] init];
          newsArticleStructure.articleID = [object objectForKey:@"articleID"];
          newsArticleStructure.authorString = [object objectForKey:@"authorString"];
          newsArticleStructure.contentURLString = [object objectForKey:@"contentURLString"];
          newsArticleStructure.dateString = [object objectForKey:@"dateString"];
          newsArticleStructure.hasImage = [object objectForKey:@"hasImage"];
          newsArticleStructure.imageURLString = [object objectForKey:@"imageURLString"];
          newsArticleStructure.likes = [object objectForKey:@"likes"];
          newsArticleStructure.summaryString = [object objectForKey:@"summaryString"];
          newsArticleStructure.titleString = [object objectForKey:@"titleString"];
          [array addObject:newsArticleStructure];
          if (i == theArrayToSearch.count - 1)
               dispatch_group_leave(serviceGroup);
     }
     if (theArrayToSearch.count == 0) {
          dispatch_group_leave(serviceGroup);
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(array);
     });
}

- (void)refreshData {
    /* activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButton;
     [activity startAnimating];*/
     [self testMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayA) {
          self.newsArticles = returnArrayA;
          NSMutableArray *itemsToSave = [NSMutableArray array];
          for (NewsArticleStructure *n in returnArrayA) {
               [itemsToSave addObject:@{ @"hasImage"     : n.hasImage,
                                         @"imageURLString"    : n.imageURLString,
                                         @"titleString" : n.titleString,
                                         
                                         @"summaryString" : n.summaryString,
                                         
                                         @"authorString" : n.authorString,
                                         
                                         @"dateString" : n.dateString,
                                         
                                         @"contentURLString" : n.contentURLString,
                                         
                                         @"articleID" : n.articleID,
                                         
                                         @"likes" : n.likes
                                         
                                         }];
          }
          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          [userDefaults setObject:itemsToSave forKey:@"newsArticles"];
          [self testMethodTwoWithCompletion:^(NSError *error, NSMutableArray *returnArray) {
               self.newsArticleImages = returnArray;
               NSMutableArray *moreItems = [NSMutableArray array];
               NSData *data;
               for (int i = 0; i < returnArray.count; i++) {
                    if ([returnArray[i] isKindOfClass:[UIImage class]]) {
                         data = [[NSData alloc] init];
                         data = UIImagePNGRepresentation(returnArray[i]);
                         [moreItems addObject:data];
                    }
                    else
                         [moreItems addObject:[[NSData alloc] init]];
                    }
               [userDefaults setObject:moreItems forKey:@"newsArticleImages"];
               [userDefaults synchronize];
               dispatch_async(dispatch_get_main_queue(), ^ {
                   // [activity stopAnimating];
                    [self.tableView reloadData];
                   /* UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
                    self.navigationItem.rightBarButtonItem = barButtonItem;*/
                    [self refreshControl];
               });
          } withArray:returnArrayA];
     }];
}

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber {
     [super init];
     self.loadNumber = theLoadNumber;
     self.navigationItem.title = @"News Center";
     return self;
}

- (void)viewWillDisappear:(BOOL)animated {
     NSMutableArray *itemsToSave = [NSMutableArray array];
     for (NewsArticleStructure *n in self.newsArticles) {
          [itemsToSave addObject:@{ @"hasImage"     : n.hasImage,
                                    @"imageURLString"    : n.imageURLString,
                                    @"titleString" : n.titleString,
                                    
                                    @"summaryString" : n.summaryString,
                                    
                                    @"authorString" : n.authorString,
                                    
                                    @"dateString" : n.dateString,
                                    
                                    @"contentURLString" : n.contentURLString,
                                    
                                    @"articleID" : n.articleID,
                                    
                                    @"likes" : n.likes
                                    
                                    }];
     }
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults setObject:itemsToSave forKey:@"newsArticles"];
     NSMutableArray *moreItems = [NSMutableArray array];
     NSData *data;
     for (int i = 0; i < self.newsArticleImages.count; i++) {
          if ([self.newsArticleImages[i] isKindOfClass:[UIImage class]]) {
               data = [[NSData alloc] init];
               data = UIImagePNGRepresentation(self.newsArticleImages[i]);
               [moreItems addObject:data];
          }
          else
               [moreItems addObject:[[NSData alloc] init]];
     }
     [userDefaults setObject:moreItems forKey:@"newsArticleImages"];
     [userDefaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     NSMutableArray *readArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"];
     if (! readArray) {
          self.readNewsArticles = [NSMutableArray array];
     } else
          self.readNewsArticles = [readArray mutableCopy];
     [self.tableView reloadData];
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
     [coder encodeObject:self.newsArticles forKey:@"newsArticles"];
     [coder encodeObject:self.newsArticleImages forKey:@"newsArticleImages"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
     self = [super init];
     if (self != nil)
     {
          self.newsArticles = [[coder decodeObjectForKey:@"newsArticles"] retain];
          self.newsArticleImages = [[coder decodeObjectForKey:@"newsArticleImages"] retain];
     }
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
     PFQuery *query = [NewsArticleStructure query];
     [query orderByAscending:@"articleID"];
     query.limit = 10;
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
     __block NSError *theError = nil;
     __block BOOL lastNone = false;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NSMutableArray *theReturnArray = [NSMutableArray arrayWithArray:array];
     NewsArticleStructure *ECStructure;
     for (int i = 0; i < array.count; i++) {
          ECStructure = (NewsArticleStructure *)[array objectAtIndex:i];
          NSInteger imageInteger = [ECStructure.hasImage integerValue];
          if (imageInteger == 1) {
               PFFile *file = ECStructure.imageFile;
               [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    theError = error;
                    UIImage *image = [UIImage imageWithData:data];
                    image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
                    [theReturnArray setObject:image atIndexedSubscript:[[NSNumber numberWithInt:i] integerValue]];
                        BOOL go = true;
                        for (NSObject *object in theReturnArray) {
                            if (object.class == [NewsArticleStructure class]) {
                                go = false;
                                break;
                            }
                        }
                        if (go) {
                            dispatch_group_leave(theServiceGroup);
                        }
               }];
          } else {
               [theReturnArray setObject:[[NSObject alloc] init] atIndexedSubscript:[[NSNumber numberWithInt:i] integerValue]];
               BOOL go = true;
               if (i == array.count - 1) {
                    for (NSObject *object in theReturnArray) {
                         if (object.class == [NewsArticleStructure class]) {
                              go = false;
                              break;
                         }
                    }
                    if (go) {
                         dispatch_group_leave(theServiceGroup);
                    }
               }
          }
     }
     if (array.count == 0) {
          dispatch_group_leave(theServiceGroup);
     }
     dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^{
          NSError *overallError = nil;
          if (theError)
               overallError = theError;
          completion(overallError, theReturnArray);
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
     if (self.newsArticles.count == 0)
          return 1;
     return self.newsArticles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 100;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 // Configure the cell...
      if (self.newsArticles.count == 0) {
           UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
           cell.textLabel.text = @"No data to display.";
           return  cell;
      } else {
           NewsArticleStructure *newsArticleStructure = ((NewsArticleStructure *)[self.newsArticles objectAtIndex:indexPath.row]);
           UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
           cell.textLabel.text = newsArticleStructure.titleString;
           cell.textLabel.numberOfLines = 0;
           cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
           cell.detailTextLabel.text = newsArticleStructure.summaryString;
           cell.detailTextLabel.numberOfLines = 4;
           NSInteger integerNumber = [newsArticleStructure.hasImage integerValue];
                if (! [self.readNewsArticles containsObject:newsArticleStructure.articleID]) {
                     UIButton *unreadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                     [unreadButton setImage:[UIImage imageNamed:@"unread@2x.png"] forState:UIControlStateNormal];
                     [unreadButton setEnabled:NO];
                     [unreadButton sizeToFit];
                     cell.accessoryView = unreadButton;
                     [cell setNeedsLayout];
                }
           if (integerNumber == 1)
                cell.imageView.image = (UIImage *)[self.newsArticleImages objectAtIndex:indexPath.row];
           return cell;
      }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     self.newsArticleSelected = self.newsArticles[indexPath.row];
     NewsArticleDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NADetail"];
     controller.NA = self.newsArticleSelected;
     controller.image = self.newsArticleImages[indexPath.row];
     [self.navigationController pushViewController:controller animated:YES];
     NSMutableArray *theReadNews = [[[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"] mutableCopy];
     if (! theReadNews) {
          theReadNews = [[NSMutableArray alloc] init];
     }
     if (! [theReadNews containsObject:self.newsArticleSelected.articleID]) {
          [theReadNews addObject:self.newsArticleSelected.articleID];
          [[NSUserDefaults standardUserDefaults] setObject:theReadNews forKey:@"readNewsArticles"];
          [[NSUserDefaults standardUserDefaults] synchronize];
     }
}



#pragma mark Table View Data Sources Methods;

/*-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section:return [self.newsArticles count];

*/

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
     //In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
      if ([segue.identifier isEqualToString:@"showDetailView"]) {
           NewsArticleDetailViewController *detailViewController = (NewsArticleDetailViewController *)[segue destinationViewController];
           detailViewController.NA = self.newsArticleSelected;
      }
 }

#pragma mark - Helper Methods

- (void)replaceNewsArticleStructure:(NewsArticleStructure *)newsArticleStructure {
     NSNumber *index = newsArticleStructure.articleID;
     NewsArticleStructure *structure;
     for (int i = 0; i < self.newsArticles.count; i++) {
          structure = (NewsArticleStructure *)self.newsArticles[i];
          if (structure.articleID == index) {
               self.newsArticles[i] = newsArticleStructure;
          }
     }
     [self.tableView reloadData];
}

@end