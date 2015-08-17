//
//  SectionsTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "SectionsTableViewController.h"
#import "NewsCenterTableViewController.h"

@interface SectionsTableViewController ()

@end

@implementation SectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
     
     self.sectionsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"News Center", @"Extracurriculars", @"Community Service", @"Student Center", @"Calendar", @"Lunch Menus", @"Useful Links", @"Staff Directory", nil]];
     self.segueIDsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"showNewsCenter", @"showExtracurriculars", @"showCommunityService", @"showStudentCenter", @"showCalendar", @"showLunchMenus", @"showUsefulLinks", @"showStaffDirectory", nil]];
     NSBundle *mainBundle = [NSBundle mainBundle];
     self.sectionsImagesArray = [[NSMutableArray alloc] init];
     [self.sectionsImagesArray addObject:@"theNews@2x.png"];
     [self.sectionsImagesArray addObject:@"extracurriculars@2x.png"];
     [self.sectionsImagesArray addObject:@"communityService@2x.png"];
     [self.sectionsImagesArray addObject:@"studentCenter@2x.png"];
     [self.sectionsImagesArray addObject:@"calendar@2x.png"];
     [self.sectionsImagesArray addObject:@"lunchMenus@2x.png"];
     [self.sectionsImagesArray addObject:@"usefulLinks@2x.png"];
     [self.sectionsImagesArray addObject:@"staffDirectory@2x.png"];
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
    return self.sectionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
     cell.textLabel.text = self.sectionsArray[indexPath.row];
          cell.imageView.image = [UIImage imageNamed:self.sectionsImagesArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
          //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
          //[self performSegueWithIdentifier:self.segueIDsArray[indexPath.row] sender:self];
     /*[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass:[MyClass class]]) {
      foundIndex = idx;
      // stop the enumeration
      *stop = YES;
      }
      }];*/
     
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableArray *visitedPagesArray = [userDefaults objectForKey:@"visitedPagesArray"];
     if (!visitedPagesArray) {
          visitedPagesArray = [[NSMutableArray alloc] init];
          [visitedPagesArray addObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]];
          [userDefaults setObject:visitedPagesArray forKey:@"visitedPagesArray"];
          [userDefaults synchronize];
          if (indexPath.row == 0) {
               NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
               [self.navigationController pushViewController:controller animated:YES];
          }
     }
     else {
          if ([visitedPagesArray containsObject:[NSString stringWithFormat:@"%lu", (long)indexPath.row]]) {
               if (indexPath.row == 0) {
                    NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:0]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
          }
          else {
               if (indexPath.row == 0) {
                    NewsCenterTableViewController *controller = [[NewsCenterTableViewController alloc] initWithLoadNumber:[NSNumber numberWithInt:1]];
                    [self.navigationController pushViewController:controller animated:YES];
               }
          }
     }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     /*NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableArray *array = [[NSMutableArray alloc] init];
     array = [userDefaults objectForKey:@"visitedSectionsArray"];
     if ([array containsObject:segue.identifier]) {
          if ([segue.identifier isEqualToString:@"showNewsCenter"]) {
               NewsCenterTableViewController *controller = (NewsCenterTableViewController *)segue.destinationViewController;
               controller.loadNumber = [NSNumber numberWithInt:1];
               NSMutableArray *newsArticlesArray = [userDefaults objectForKey:@"newsArticles"];
               if (newsArticlesArray)
                    controller.newsArticles = newsArticlesArray;
               NSMutableArray *newsImagesArray = [userDefaults objectForKey:@"newsArticleImages"];
               if (newsImagesArray)
                    controller.newsArticleImages = newsImagesArray;
          }
     } else {
          if (! array) {
               array = [[NSMutableArray alloc] init];
          }
          [array addObject:segue.identifier];
          [userDefaults setObject:array forKey:@"visitedSectionsArray"];
          [userDefaults synchronize];
     }*/
}


@end
