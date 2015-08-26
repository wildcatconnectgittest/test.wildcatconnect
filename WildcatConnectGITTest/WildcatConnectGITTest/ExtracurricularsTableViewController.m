//
//  ExtracurricularsTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "ExtracurricularsTableViewController.h"
#import "ExtracurricularStructure.h"
#import "ExtracurricularUpdateStructure.h"
#import "AppManager.h"

@interface ExtracurricularsTableViewController ()

@end

@implementation ExtracurricularsTableViewController {
     UIActivityIndicatorView *activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     if (self.loadNumber == [NSNumber numberWithInt:1] || ! self.loadNumber) {
          [self refreshData];
     } else {
          activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
          [activity setBackgroundColor:[UIColor clearColor]];
          [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
          UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
          self.navigationItem.rightBarButtonItem = barButton;
          [activity startAnimating];
          [self getOldUpdatesWithCompletion:^(NSMutableArray *returnArray) {
               self.updatesArray = returnArray;
               [self getOldUpdatesTwoWithCompletion:^(NSMutableArray *returnArrayB) {
                    self.extracurricularsArray = returnArrayB;
                    [self getOldImagesWithCompletion:^(NSMutableArray *returnArrayC) {
                         self.ECImagesArray = returnArrayC;
                         dispatch_async(dispatch_get_main_queue(), ^ {
                              [activity stopAnimating];
                              [self.tableView reloadData];
                              UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
                              self.navigationItem.rightBarButtonItem = barButtonItem;
                              [self refreshControl];
                         });
                    }];
               }];
          }];
     }
}

- (void)refreshData {
     [self testMethodWithCompletion:^(NSError *error, NSMutableArray *returnArray) {
          self.updatesArray = returnArray;
          NSMutableArray *itemsToSave = [NSMutableArray array];
          for (ExtracurricularUpdateStructure *e in returnArray) {
               [itemsToSave addObject:@{ @"extracurricularID"     : e.extracurricularID,
                                         @"messageString"    : e.messageString,
                                         @"extracurricularUpdateID" :e.extracurricularUpdateID
                                         }];
          }
          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          [userDefaults setObject:itemsToSave forKey:@"ECUpdates"];
          [self testMethodTwoWithCompletion:^(NSError *error, NSMutableArray *returnArrayA) {
               self.extracurricularsArray = returnArrayA;
               NSMutableArray *moreItems = [NSMutableArray array];
               for (ExtracurricularStructure *e in returnArrayA) {
                    [moreItems addObject:@{ @"titleString"     : e.titleString,
                                            @"descriptionString"    : e.descriptionString,
                                            @"hasImage" :e.hasImage,
                                            @"imageURLString": e.imageURLString,
                                            @"meetingString" : e.meetingString,
                                            @"contactInformationDictionary" : e.contactInformationDictionary,
                                            @"extracurricularID" : e.extracurricularID
                                            }];
               }
               [userDefaults setObject:moreItems forKey:@"ECArray"];
               [self testMethodThreeWithCompletion:^(NSError *error, NSMutableArray *returnArrayB) {
                    self.ECImagesArray = returnArrayB;
                    NSMutableArray *moreItems = [NSMutableArray array];
                    NSData *data;
                    for (int i = 0; i < returnArrayB.count; i++) {
                         if ([returnArrayB[i] isKindOfClass:[UIImage class]]) {
                              data = [[NSData alloc] init];
                              data = UIImagePNGRepresentation(returnArrayB[i]);
                              [moreItems addObject:data];
                         } else {
                              [moreItems addObject:[[NSData alloc] init]];
                         }
                    }
                    [userDefaults setObject:moreItems forKey:@"ECImagesArray"];
                    [userDefaults synchronize];
                    dispatch_async(dispatch_get_main_queue(), ^ {
                         [activity stopAnimating];
                         [self.tableView reloadData];
                         UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
                         self.navigationItem.rightBarButtonItem = barButtonItem;
                         [self refreshControl];
                    });;
               } withArray:returnArrayA];
          }];
     }];
}

- (void)getOldUpdatesTwoWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     ExtracurricularStructure *ECStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"ECArray"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          object = theArrayToSearch[i];
          ECStructure = [[ExtracurricularStructure alloc] init];
          ECStructure.titleString = [object objectForKey:@"titleString"];
          ECStructure.descriptionString = [object objectForKey:@"descriptionString"];
          ECStructure.hasImage = [object objectForKey:@"hasImage"];
          ECStructure.imageURLString = [object objectForKey:@"imageURLString"];
          ECStructure.meetingString = [object objectForKey:@"meetingString"];
          ECStructure.contactInformationDictionary = [object objectForKey:@"contactInformationDictionary"];
          ECStructure.extracurricularID = [object objectForKey:@"extracurricularID"];
          [array addObject:ECStructure];
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

- (void)getOldImagesWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
          //Start the first service
     dispatch_group_enter(serviceGroup);
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"ECImagesArray"];
     NSData *data;
     UIImage *image;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          data = theArrayToSearch[i];
          image = [UIImage imageWithData:data];
          if (image)
               [array addObject:image];
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

- (void)getOldUpdatesWithCompletion:(void (^)(NSMutableArray *returnArray))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     ExtracurricularUpdateStructure *ECUpdateStructure;
     NSMutableArray *array = [[NSMutableArray alloc] init];
     NSMutableArray *theArrayToSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"ECUpdates"];
     NSDictionary *object;
     for (int i = 0; i < theArrayToSearch.count; i++) {
          object = theArrayToSearch[i];
          ECUpdateStructure = [[ExtracurricularUpdateStructure alloc] init];
          ECUpdateStructure.extracurricularID = [object objectForKey:@"extracurricularID"];
          ECUpdateStructure.messageString = [object objectForKey:@"messageString"];
          ECUpdateStructure.extracurricularUpdateID = [object objectForKey:@"extracurricularUpdateID"];
          [array addObject:ECUpdateStructure];
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

- (void)testMethodFourWithCompletion:(void (^)(NSError *error, NSData *data))completion withFile:(PFFile *)file {
     __block NSError *theError = nil;
     __block NSData *theData;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
          theData = data;
          theError = error;
          dispatch_group_leave(theServiceGroup);
     }];
     dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError)
               overallError = theError;
          completion(theError, theData);
     });
}

- (void)testMethodThreeWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion withArray:(NSMutableArray *)array {
     __block NSError *theError = nil;
     __block BOOL lastNone = false;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NSMutableArray *theReturnArray = [NSMutableArray arrayWithArray:array];
     ExtracurricularStructure *ECStructure;
     for (int i = 0; i < array.count; i++) {
          ECStructure = (ExtracurricularStructure *)[array objectAtIndex:i];
          if (ECStructure.hasImage == [NSNumber numberWithInt:1]) {
               PFFile *file = ECStructure.imageFile;
               [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                    image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
                    [theReturnArray setObject:image atIndexedSubscript:[[NSNumber numberWithInt:i] integerValue]];
                    if (i == array.count - 1) {
                         dispatch_group_leave(theServiceGroup);
                    }
               }];
          } else {
               [theReturnArray setObject:[[NSObject alloc] init] atIndexedSubscript:[[NSNumber numberWithInt:i] integerValue]];
               if (i == array.count - 1) {
                    dispatch_group_leave(theServiceGroup);
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

- (void)testMethodTwoWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion {
     __block NSError *theError = nil;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NSMutableArray *theReturnArray = [[NSMutableArray alloc] init];
     PFQuery *query = [ExtracurricularStructure query];
     [query orderByAscending:@"extracurricularID"];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          [theReturnArray addObjectsFromArray:objects];
          theError = error;
          dispatch_group_leave(theServiceGroup);
     }];
     dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError)
               overallError = theError;
          completion(overallError, theReturnArray);
     });
}

- (void)testMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion {
     __block NSError *theError = nil;
     dispatch_group_t theServiceGroup = dispatch_group_create();
     dispatch_group_enter(theServiceGroup);
     NSMutableArray *returnArray = [[NSMutableArray alloc] init];
          //Return array will be updatesArray
     PFQuery *query = [ExtracurricularUpdateStructure query];
     [query orderByDescending:@"createdAt"];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          [returnArray addObjectsFromArray:objects];
          theError = error;
          dispatch_group_leave(theServiceGroup);
     }];
     dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError)
               overallError = theError;
          completion(overallError, returnArray);
     });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber {
     [super init];
     self.loadNumber = theLoadNumber;
     self.navigationItem.title = @"Extracurriculars";
     return self;
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
     if (section == 0) {
          if (self.updatesArray.count == 0) {
               return 1;
          } else
               return self.updatesArray.count;
     } else if (section == 1) {
          if (self.extracurricularsArray.count == 0) {
               return 1;
          } else
               return self.extracurricularsArray.count;
     }
     else return nil;
}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
          // Configure the cell...
     
    return cell;
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if (section == 0)
          return @"UPDATES";
     else if (section == 1)
          return @"ALL EXTRACURRICULARS";
     else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
          if (self.updatesArray.count == 0) {
               UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
               cell.textLabel.text = @"No updates to display.";
               return  cell;
          } else {
               ExtracurricularUpdateStructure *extracurricularUpdateStructure = ((ExtracurricularUpdateStructure *)[self.updatesArray objectAtIndex:indexPath.row]);
               ExtracurricularStructure *EC = [extracurricularUpdateStructure getStructureForUpdate:extracurricularUpdateStructure withArray:[self.extracurricularsArray copy]];
               UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
               cell.textLabel.text = EC.titleString;
               cell.detailTextLabel.text = extracurricularUpdateStructure.messageString;
               cell.detailTextLabel.numberOfLines = 4;
               NSNumber *index = EC.extracurricularID;
               NSUInteger *theIndex = [index integerValue];
               if (EC.hasImage == [NSNumber numberWithInt:1])
                    cell.imageView.image = (UIImage *)[self.ECImagesArray objectAtIndex:theIndex];
               return cell;
          }
     } else if (indexPath.section == 1) {
          if (self.extracurricularsArray.count == 0) {
               UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
               cell.textLabel.text = @"No data to display.";
               return  cell;
          } else {
               ExtracurricularStructure *extracurricularStructure = ((ExtracurricularStructure *)[self.extracurricularsArray objectAtIndex:indexPath.row]);
               UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
               cell.textLabel.text = extracurricularStructure.titleString;
               cell.detailTextLabel.text = extracurricularStructure.descriptionString;
               cell.detailTextLabel.numberOfLines = 4;
               if (extracurricularStructure.hasImage == [NSNumber numberWithInt:1])
                    cell.imageView.image = (UIImage *)[self.ECImagesArray objectAtIndex:indexPath.row];
               return cell;
          }
     }
     else return nil;
}

- (NSInteger)getIndexofStructureWithID:(NSNumber *)theID {
     for (int i = 0; i < self.extracurricularsArray.count; i++) {
          if (((ExtracurricularStructure *)(self.extracurricularsArray[i])).extracurricularID == theID)
               return i;
     }
     return nil;
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
