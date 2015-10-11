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
                    [self getPreviousNewImagesWithCompletion:^(NSMutableArray *returnArrayC) {
                         self.newImages = returnArrayC;
                         [self getPreviousOldImagesWithCompletion:^(NSMutableArray *returnArrayD) {
                              self.oldImages = returnArrayD;
                              dispatch_async(dispatch_get_main_queue(), ^ {
                                   [self.tableView reloadData];
                                   [self refreshControl];
                              });
                         }];
                    }];
                }];
          }];
     }
}

-(void)refresh {
    [self refreshData];
    }

- (void)refreshData {
     [self testMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayA) {
          self.allOpps = returnArrayA;
          [self testMethodThreeWithCompletion:^(NSMutableArray *returnArrayB, NSMutableArray *returnArray2) {
               self.newOpps = returnArray2;
               self.oldOpps = returnArrayB;
               NSMutableArray *itemsToSave = [NSMutableArray array];
               for (CommunityServiceStructure *c in returnArray2) {
                    [itemsToSave addObject:@{ @"commTitleString"     : c.commTitleString,
                                              @"commPreviewString"    : c.commPreviewString , @"commSummaryString" : c.commSummaryString, @"IsNewNumber" : c.IsNewNumber, @"hasImage" : c.hasImage, @"communityServiceID"  : c.communityServiceID
                                              }];
               }
               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
               [userDefaults setObject:itemsToSave forKey:@"newCommServiceItems"];
               itemsToSave = [NSMutableArray array];
               for (CommunityServiceStructure *c in returnArrayB) {
                    [itemsToSave addObject:@{ @"commTitleString"     : c.commTitleString,
                                              @"commPreviewString"    : c.commPreviewString, @"commSummaryString" : c.commSummaryString, @"IsNewNumber" : c.IsNewNumber, @"hasImage" : c.hasImage, @"communityServiceID"  : c.communityServiceID
                                              }];
               }
               [userDefaults setObject:itemsToSave forKey:@"oldCommServiceItems"];
               [self newImagesMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayX) {
                    self.newImages = returnArrayX;
                    NSMutableArray *moreItems = [NSMutableArray array];
                    NSData *data;
                    for (int i = 0; i < returnArrayX.count; i++) {
                         if ([returnArrayX[i] isKindOfClass:[UIImage class]]) {
                              data = [[NSData alloc] init];
                              data = UIImagePNGRepresentation(returnArrayX[i]);
                              [moreItems addObject:data];
                         } else {
                              [moreItems addObject:[[NSData alloc] init]];
                         }
                    }
                    [userDefaults setObject:moreItems forKey:@"newCommServiceImages"];
                    [self oldImagesMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayU) {
                         self.oldImages = returnArrayU;
                         NSMutableArray *moreItemsTwo = [NSMutableArray array];
                         NSData *data;
                         for (int i = 0; i < returnArrayU.count; i++) {
                              if ([returnArrayU[i] isKindOfClass:[UIImage class]]) {
                                   data = [[NSData alloc] init];
                                   data = UIImagePNGRepresentation(returnArrayU[i]);
                                   [moreItemsTwo addObject:data];
                              } else {
                                   [moreItemsTwo addObject:[[NSData alloc] init]];
                              }
                         }
                         [userDefaults setObject:moreItems forKey:@"oldCommServiceImages"];
                         [userDefaults synchronize];
                         dispatch_async(dispatch_get_main_queue(), ^ {
                              [activity stopAnimating];
                              [self.tableView reloadData];
                             [self.refreshControl endRefreshing];
                         });
                    } withArray:returnArrayB];
               } withArray:returnArray2];
          } withArray:returnArrayA];
     }];

}

- (void)getPreviousOldImagesWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldCommServiceImages"];
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

- (void)getPreviousNewImagesWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"newCommServiceImages"];
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
          CSStructure.commPreviewString = [object objectForKey:@"commPreviewString"];
          CSStructure.commSummaryString = [object objectForKey:@"commSummaryString"];
          CSStructure.IsNewNumber = [object objectForKey:@"IsNewNumber"];
          CSStructure.hasImage = [object objectForKey:@"hasImage"];
          CSStructure.communityServiceID = [object objectForKey:@"communityServiceID"];
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
          CSStructure.commPreviewString = [object objectForKey:@"commPreviewString"];
          CSStructure.commSummaryString = [object objectForKey:@"commSummaryString"];
          CSStructure.IsNewNumber = [object objectForKey:@"IsNewNumber"];
          CSStructure.hasImage = [object objectForKey:@"hasImage"];
          CSStructure.communityServiceID = [object objectForKey:@"communityServiceID"];
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

- (void)newImagesMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion withArray:(NSMutableArray *)array {
     __block NSError *theError = nil;
     __block BOOL lastNone = false;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NSMutableArray *theReturnArray = [NSMutableArray arrayWithArray:array];
     CommunityServiceStructure *CSStructure;
     for (int i = 0; i < array.count; i++) {
          CSStructure = (CommunityServiceStructure *)[array objectAtIndex:i];
          NSInteger *integer = [CSStructure.hasImage integerValue];
          if (integer == 1) {
               PFFile *file = CSStructure.commImageFile;
               [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    theError = error;
                    UIImage *image = [UIImage imageWithData:data];
                    image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
                    [theReturnArray setObject:image atIndexedSubscript:[[NSNumber numberWithInt:i] integerValue]];
                    BOOL go = true;
                    for (NSObject *object in theReturnArray) {
                         if (object.class == [CommunityServiceStructure class]) {
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
               if (i == array.count - 1) {
                    BOOL go = true;
                    for (NSObject *object in theReturnArray) {
                         if (object.class == [CommunityServiceStructure class]) {
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

- (void)oldImagesMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion withArray:(NSMutableArray *)array {
     __block NSError *theError = nil;
     __block BOOL lastNone = false;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NSMutableArray *theReturnArray = [NSMutableArray arrayWithArray:array];
     CommunityServiceStructure *CSStructure;
     for (int i = 0; i < array.count; i++) {
          CSStructure = (CommunityServiceStructure *)[array objectAtIndex:i];
          NSInteger *integer = [CSStructure.hasImage integerValue];
          if (integer == 1) {
               PFFile *file = CSStructure.commImageFile;
               [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    theError = error;
                    UIImage *image = [UIImage imageWithData:data];
                    image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
                    [theReturnArray setObject:image atIndexedSubscript:[[NSNumber numberWithInt:i] integerValue]];
                    BOOL go = true;
                    for (NSObject *object in theReturnArray) {
                         if (object.class == [CommunityServiceStructure class]) {
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
               if (i == array.count - 1) {
                    BOOL go = true;
                    for (NSObject *object in theReturnArray) {
                         if (object.class == [CommunityServiceStructure class]) {
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
    [query orderByAscending:@"communityServiceID"];
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
                  cell.detailTextLabel.text = commServiceStructure.commSummaryString;
                  cell.detailTextLabel.numberOfLines = 4;
                  NSInteger integer = [commServiceStructure.hasImage integerValue];
                  if (integer == 1) {
                       cell.imageView.image = (UIImage *)[self.newImages objectAtIndex:indexPath.row];
                  }
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
                  cell.detailTextLabel.text = commServiceStructure.commSummaryString;
                  cell.detailTextLabel.numberOfLines = 4;
                  NSInteger integer = [commServiceStructure.hasImage integerValue];
                  if (integer == 1)
                       cell.imageView.image = (UIImage *)[self.oldImages objectAtIndex:indexPath.row];
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
    return 100;
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
