//
//  NewsCenterTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "NewsCenterTableViewController.h"
#import "AppManager.h"

@implementation NewsCenterTableViewController {
     AppManager *manager;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     
          // Uncomment the following line to preserve selection between presentations.
          // self.clearsSelectionOnViewWillAppear = NO;
     
          // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
          // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     manager = [AppManager getInstance];
     NSLog(@"%@", manager.testString);
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
     return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 100;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 // Configure the cell...
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
      cell.textLabel.text = @"Testing...";
      cell.detailTextLabel.text = @"Testing more!";
      cell.imageView.image = [manager imageFromImage:[[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:@"http://www.kevinalyons.com/assets/BTC%20Picture%20B.jpg"]]] scaledToWidth:70];
      return cell;
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