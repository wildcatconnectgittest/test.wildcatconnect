//
//  PushSettingsTableViewController.m
//  WildcatConnect
//
//  Created by Kevin Lyons on 12/12/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "PushSettingsTableViewController.h"
#import <Parse/Parse.h>
#import "ExtracurricularStructure.h"

@interface PushSettingsTableViewController ()

@end

@implementation PushSettingsTableViewController {
     BOOL hasChanged;
     UIActivityIndicatorView *activity;
     UIAlertView *postAlertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
     hasChanged = false;
     
     self.navigationItem.title = @"Push Notifications";
     
     self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButtonItem;
     [activity startAnimating];
     
     [self getExtracurricularsMethodWithCompletion:^(NSMutableArray *returnArray, NSError *error) {
          if (error != nil) {
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Error fetching data from server. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
               [alertView show];
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [activity stopAnimating];
               });
          } else {
               self.ECarray = returnArray;
               [[PFInstallation currentInstallation] fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    self.pushArray = [NSMutableArray arrayWithArray:((PFInstallation *)object).channels];
                    [activity stopAnimating];
                    [self.tableView reloadData];
               }];
          }
     }];
}

- (void)getExtracurricularsMethodWithCompletion:(void (^)(NSMutableArray *returnArray, NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *returnArray = [NSMutableArray array];
     PFQuery *query = [ExtracurricularStructure query];
     [query orderByAscending:@"titleString"];
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          [returnArray addObjectsFromArray:objects];
          if (error != nil) {
               theError = error;
          }
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError != nil && returnArray.count == 0) {
               overallError = theError;
          }
          completion(returnArray, overallError);
     });
}

- (void)getChannelsMethodWithCompletion:(void (^)(NSMutableArray *returnArray, NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *returnArray = [NSMutableArray array];
     PFQuery *query = [PFInstallation query];
     [query whereKey:@"deviceToken" equalTo:[[PFInstallation currentInstallation] deviceToken]];
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          [returnArray addObjectsFromArray:[[objects objectAtIndex:0] objectForKey:@"channels"]];
          if (error != nil) {
               theError = error;
          }
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError != nil && returnArray.count == 0) {
               overallError = theError;
          }
          completion(returnArray, overallError);
     });
}

- (instancetype)init {
     [super init];
     self.navigationItem.title = @"Push Notifications";
     return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (section == 0) {
          return 2;
     } else if (section == 1) {
          if (self.ECarray.count == 0) {
               return 1;
          } else return self.ECarray.count;
     } else return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if (section == 0) {
          return @"SELECT THE PUSH NOTIFICATIONS YOU WOULD LIKE TO RECEIVE...";
     } else if (section == 1) {
          return @"EXTRACURRICULARS";
     } else return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
     
     UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
     
     if (indexPath.section == 0) {
          if (indexPath.row == 0) {
               if (self.pushArray.count > 0 && [self.pushArray containsObject:@"allNews"]) {
                    [switchView setOn:YES animated:NO];
               } else
                    [switchView setOn:NO animated:NO];
          } else if (indexPath.row == 1) {
               if (self.pushArray.count > 0 && [self.pushArray containsObject:@"allCS"]) {
                    [switchView setOn:YES animated:NO];
               } else
                    [switchView setOn:NO animated:NO];
          }
     } else if (indexPath.section == 1) {
          ExtracurricularStructure *EC = [self.ECarray objectAtIndex:indexPath.row];
          if (self.pushArray.count != 0 && [self.pushArray containsObject:EC.channelString]) {
               [switchView setOn:YES animated:NO];
          } else
               [switchView setOn:NO animated:NO];
     }
     
     [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
     
     if (indexPath.section == 0) {
          if (indexPath.row == 0) {
               cell.textLabel.text = @"All News Articles";
               [switchView setTag:0];
          } else if (indexPath.row == 1) {
               cell.textLabel.text = @"All Community Service";
               [switchView setTag:1];
          }
          cell.accessoryView = switchView;
     } else if (indexPath.section == 1) {
          if (self.ECarray.count == 0) {
               cell.textLabel.text = @"Loading...";
          } else {
               ExtracurricularStructure *EC = [self.ECarray objectAtIndex:indexPath.row];
               cell.textLabel.text = EC.titleString;
               NSInteger integer = indexPath.row + 2;
               [switchView setTag:integer];
               cell.accessoryView = switchView;
          }
     }
     
     [switchView release];
    
     return cell;
}

- (void)switchChanged:(id)sender {
     hasChanged = true;
     UISwitch* switchControl = sender;
     if (switchControl.tag == 0) {
          if (switchControl.on == true) {
               if (! [self.pushArray containsObject:@"allNews"]) {
                    [self.pushArray addObject:@"allNews"];
               }
          } else {
               if ([self.pushArray containsObject:@"allNews"]) {
                    [self.pushArray removeObject:@"allNews"];
               }
          }
     } else if (switchControl.tag == 1) {
          if (switchControl.on == true) {
               if (! [self.pushArray containsObject:@"allCS"]) {
                    [self.pushArray addObject:@"allCS"];
               }
          } else {
               if ([self.pushArray containsObject:@"allCS"]) {
                    [self.pushArray removeObject:@"allCS"];
               }
          }
     } else {
          ExtracurricularStructure *EC = [self.ECarray objectAtIndex:switchControl.tag - 2];
          if (switchControl.on == true) {
               if (! [self.pushArray containsObject:EC.channelString]) {
                    [self.pushArray addObject:EC.channelString];
               }
          } else {
               if ([self.pushArray containsObject:EC.channelString]) {
                    [self.pushArray removeObject:EC.channelString];
               }
          }
     }
     if (self.pushArray.count > 1 || hasChanged == true) {
          hasChanged = true;
          UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveChannels)];
          self.navigationItem.rightBarButtonItem = barButtonItem;
     } else
          self.navigationItem.rightBarButtonItem = nil;
}

- (void)saveChannels {
     postAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you save these Push Notification settings?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
     [postAlertView show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     if (actionSheet == postAlertView) {
          if (buttonIndex == 1) {
               activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
               [activity setBackgroundColor:[UIColor clearColor]];
               [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
               UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
               self.navigationItem.rightBarButtonItem = barButtonItem;
               [activity startAnimating];
               [self saveChannelsMethodWithCompletion:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [activity stopAnimating];
                         [self.navigationController popViewControllerAnimated:YES];
                    });
               }];
          }
          
     }
}

- (void)saveChannelsMethodWithCompletion:(void (^)(NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     PFInstallation *currentInstallation = [PFInstallation currentInstallation];
     [currentInstallation setObject:self.pushArray forKey:@"channels"];
     [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
          theError = error;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(theError);
     });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
