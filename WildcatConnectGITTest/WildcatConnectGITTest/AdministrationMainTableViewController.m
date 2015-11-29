//
//  AdministrationMainTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/4/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "AdministrationMainTableViewController.h"
#import <Parse/Parse.h>
#import "AdministrationLogInViewController.h"
#import "ComposeNewsArticleViewController.h"
#import "ComposeExtracurricularUpdateViewController.h"
#import "ComposeCommunityServiceViewController.h"
#import "ComposePollViewController.h"
#import "EditMessagesViewController.h"
#import "EditPictureDayViewController.h"
#import "ComposeAlertViewController.h"

@interface AdministrationMainTableViewController ()

@end

@implementation AdministrationMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutCurrentUser)];
     self.navigationItem.rightBarButtonItem = logoutButton;
     [logoutButton release];
     
     NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
     NSString *lastName = [[PFUser currentUser] objectForKey:@"lastName"];
     
     self.topBar.topItem.title = [[lastName stringByAppendingString:@", "] stringByAppendingString:firstName];
     
     self.sectionsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"News Article", @"Extracurricular Update", @"Community Service Update", @"User Poll", @"Alert", nil]];
     self.sectionsImagesArray = [[NSMutableArray alloc] init];
     [self.sectionsImagesArray addObject:@"theNews@2x.png"];
     [self.sectionsImagesArray addObject:@"extracurriculars@2x.png"];
     [self.sectionsImagesArray addObject:@"communityService@2x.png"];
     [self.sectionsImagesArray addObject:@"studentCenter@2x.png"];
     [self.sectionsImagesArray addObject:@"alerts@2x.png"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)logOutCurrentUser {
     [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
          [self.navigationController popToRootViewControllerAnimated:YES];
     }];
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
     } else
          return self.sectionsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if (section == 0) {
          return @"DAILY UPDATES";
     } else
          return @"COMPOSE NEW";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
     return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
     if (indexPath.section == 0) {
          if (indexPath.row == 0) {
               cell.textLabel.text = @"Messages";
               cell.imageView.image = [UIImage imageNamed:@"message@2x.png"];
          } else if (indexPath.row == 1) {
               cell.textLabel.text = @"Picture of the Day";
               cell.imageView.image = [UIImage imageNamed:@"picture@2x.png"];
          }
     } else {
          cell.textLabel.text = self.sectionsArray[indexPath.row];
          cell.imageView.image = [UIImage imageNamed:self.sectionsImagesArray[indexPath.row]];
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
          if (indexPath.row == 0) {
               EditMessagesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditMessages"];
               [self.navigationController pushViewController:controller animated:YES];
          } else if (indexPath.row == 1) {
               EditPictureDayViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditPicture"];
               [self.navigationController pushViewController:controller animated:YES];
          }
     } else if (indexPath.section == 1) {
          if (indexPath.row == 0) {
               ComposeNewsArticleViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ComposeNewsArticle"];
               [self.navigationController pushViewController:controller animated:YES];
          } else if (indexPath.row == 1) {
               ComposeExtracurricularUpdateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ComposeExtracurricular"];
               [self.navigationController pushViewController:controller animated:YES];
          } else if (indexPath.row == 2) {
               ComposeCommunityServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ComposeCommunity"];
               [self.navigationController pushViewController:controller animated:YES];
          } else if (indexPath.row == 3) {
               ComposePollViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComposePoll"];
               [self.navigationController pushViewController:controller animated:YES];
          } else if (indexPath.row == 4) {
               ComposeAlertViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComposeAlert"];
               [self.navigationController pushViewController:controller animated:YES];
          }
     }
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

- (void)dealloc {
     [_topBar release];
     [super dealloc];
}
@end
