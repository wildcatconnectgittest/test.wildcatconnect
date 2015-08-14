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
     AppManager *manager;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     
          // Uncomment the following line to preserve selection between presentations.
          // self.clearsSelectionOnViewWillAppear = NO;
     
          // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
          // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     manager = [AppManager getInstance];
     /*UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"theNews@2x.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:nil];
     barButton.enabled = false;
     UIBarButtonItem *barButtonTwo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"theNews@2x.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:nil];
     barButtonTwo.enabled = false;
     self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:barButton, barButtonTwo, nil];*/
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
     manager = [AppManager getInstance];
     return manager.newsArticles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 100;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 // Configure the cell...
      NewsArticleStructure *newsArticleStructure = ((NewsArticleStructure *)[manager.newsArticles objectAtIndex:indexPath.row]);
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
      cell.textLabel.text = newsArticleStructure.titleString;
      cell.detailTextLabel.text = newsArticleStructure.summaryString;
      cell.detailTextLabel.numberOfLines = 4;
      if (newsArticleStructure.hasImage == [NSNumber numberWithInt:1])
           cell.imageView.image = (UIImage *)[manager.newsArticleImages objectAtIndex:indexPath.row];
      return cell;
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