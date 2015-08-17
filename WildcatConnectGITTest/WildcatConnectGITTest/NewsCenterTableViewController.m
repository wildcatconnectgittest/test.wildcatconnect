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

@implementation NewsCenterTableViewController {
     UIActivityIndicatorView *activity;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     NSLog(@"%@ sfjsljfs", self.loadNumber);
          if (self.loadNumber == [NSNumber numberWithInt:1]) {
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
                    NSLog(@"Made it here!!!");
                    NSLog(@"%lu", (unsigned long)returnArray.count);
                    self.newsArticles = returnArray;
                    [self getOldImagesWithCompletion:^(NSMutableArray *returnArrayB) {
                         self.newsArticleImages = returnArrayB;
                         dispatch_async(dispatch_get_main_queue(), ^ {
                              [activity stopAnimating];
                              [self.tableView reloadData];
                              UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
                              self.navigationItem.rightBarButtonItem = barButtonItem;
                         });
                    }];
               }];
          }
}

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
          [array addObject:image];
          if (i == theArrayToSearch.count - 1) {
               dispatch_group_leave(serviceGroup);
          }
     }
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(array);
     });
}

- (void)getOldDataWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
          //Start the first service
     dispatch_group_enter(serviceGroup);
     NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"newsArticles"]);
     NewsArticleStructure *newsArticleStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"newsArticles"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i ++) {
          object = theArrayToSearch[i];
          newsArticleStructure = [[NewsArticleStructure alloc] init];
          newsArticleStructure.articleIDString = [object objectForKey:@"articleIDString"];
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
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(array);
     });
}

- (void)refreshData {
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButton;
     [activity startAnimating];
     [self testMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayA) {
          NSLog(@"Done!");
          NSLog(@"%@", returnArrayA);
          self.newsArticles = returnArrayA;
          NSMutableArray *itemsToSave = [NSMutableArray array];
          for (NewsArticleStructure *n in returnArrayA) {
               NSLog(@"%@", n);
               [itemsToSave addObject:@{ @"hasImage"     : n.hasImage,
                                         @"imageURLString"    : n.imageURLString,
                                         @"titleString" : n.titleString,
                                         
                                         @"summaryString" : n.summaryString,
                                         
                                         @"authorString" : n.authorString,
                                         
                                         @"dateString" : n.dateString,
                                         
                                         @"contentURLString" : n.contentURLString,
                                         
                                         @"articleIDString" : n.articleIDString,
                                         
                                         @"likes" : n.likes
                                         
                                         }];
          }
          NSLog(@"%@", itemsToSave);
          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          [userDefaults setObject:itemsToSave forKey:@"newsArticles"];
          NSLog(@"%@", [userDefaults objectForKey:@"newsArticles"]);
          [self testMethodTwoWithCompletion:^(NSError *error, NSMutableArray *returnArray) {
               NSLog(@"Made it here!!!");
               NSLog(@"%lu", (unsigned long)returnArray.count);
               self.newsArticleImages = returnArray;
               NSMutableArray *moreItems = [NSMutableArray array];
               NSData *data;
               for (UIImage *image in returnArray) {
                    data = UIImagePNGRepresentation(image);
                    [moreItems addObject:data];
               }
               [userDefaults setObject:moreItems forKey:@"newsArticleImages"];
               [userDefaults synchronize];
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [activity stopAnimating];
                    [self.tableView reloadData];
                    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
                    self.navigationItem.rightBarButtonItem = barButtonItem;
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
     /*NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSArray *testArray = [userDefaults objectForKey:@"newsArticles"];
     NSArray *newsArticleArray = [NSArray arrayWithArray:self.newsArticles];
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsArticleArray];
     [userDefaults setObject:data forKey:@"newsArticles"];
          //[userDefaults setValue:newsArticleArray forKey:@"newsArticles"];          //[userDefaults setObject:self.newsArticleImages forKey:@"newsArticleImages2"];
     [userDefaults synchronize];*/
     NSMutableArray *itemsToSave = [NSMutableArray array];
     for (NewsArticleStructure *n in self.newsArticles) {
          [itemsToSave addObject:@{ @"hasImage"     : n.hasImage,
                                    @"imageURLString"    : n.imageURLString,
                                    @"titleString" : n.titleString,
                                    
                                    @"summaryString" : n.summaryString,
                                    
                                    @"authorString" : n.authorString,
                                    
                                    @"dateString" : n.dateString,
                                    
                                    @"contentURLString" : n.contentURLString,
                                    
                                    @"articleIDString" : n.articleIDString,
                                    
                                    @"likes" : n.likes
                                    
                                    }];
     }
     NSLog(@"%@", itemsToSave);
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults setObject:itemsToSave forKey:@"newsArticles"];
     [userDefaults synchronize];
     NSLog(@"%@", [userDefaults objectForKey:@"newsArticles"]);
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
     [query orderByDescending:@"createdAt"];
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
     /*NewsArticleStructure *newsArticleStructure;
      for (int i = 0; i < newsArticles.count; i++) {
      newsArticleStructure = (NewsArticleStructure *)[newsArticles objectAtIndex:i];
      PFFile *file = newsArticleStructure.imageFile;
      NSData *data = [file getData];
      UIImage *image = [UIImage imageWithData:data];
      image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
      [self.newsArticleImages addObject:image];
      }*/
     __block NSError *theError = nil;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NewsArticleStructure *newsArticleStructure;
     NSLog(@"Doing it...");
     NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     NSLog(@"%lu", (unsigned long)array.count);
     for (int i = 0; i < array.count; i++) {
          NSLog(@"%i", i);
          newsArticleStructure = (NewsArticleStructure *)[array objectAtIndex:i];
          if (newsArticleStructure.hasImage == [NSNumber numberWithInt:1]) {
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
          }
     }
     dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^{
          NSError *overallError = nil;
          if (theError)
               overallError = theError;
          completion(overallError, returnArray);
     });
}

- (void) functionDoingBackgroundWorkWithCompletionHandler {
     
     dispatch_group_t taskGroup = dispatch_group_create();
     dispatch_group_enter(taskGroup);
     PFQuery *query = [NewsArticleStructure query];
     [query orderByAscending:@"createdAt"];
     query.limit = 10;
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          if (! error) {
               self.newsArticles = (NSMutableArray *)objects;
               dispatch_group_leave(taskGroup);
          }
     }];
     dispatch_queue_t waitingQueue = dispatch_queue_create("com.WildcatConnect.WildcatConnectGITTest.waitingQueue", DISPATCH_QUEUE_CONCURRENT);
     dispatch_async(waitingQueue, ^ {
               //Waiting for threads.
          dispatch_group_wait(taskGroup, DISPATCH_TIME_FOREVER);
          dispatch_release(taskGroup);
               //Background work complete
          dispatch_async(dispatch_get_main_queue(), ^ {
               NSLog(@"%@", newsArticles);
          });
          dispatch_release(waitingQueue);
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
     NSLog(@"Just did thisfjslsdjflsdfjsdl.");
     NSLog(@"%lu", (unsigned long)self.newsArticles.count);
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
           cell.detailTextLabel.text = newsArticleStructure.summaryString;
           cell.detailTextLabel.numberOfLines = 4;
           if (newsArticleStructure.hasImage == [NSNumber numberWithInt:1])
                cell.imageView.image = (UIImage *)[self.newsArticleImages objectAtIndex:indexPath.row];
           return cell;
      }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
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