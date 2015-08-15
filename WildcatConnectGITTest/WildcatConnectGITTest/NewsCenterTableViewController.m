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
          // Uncomment the following line to preserve selection between presentations.
          // self.clearsSelectionOnViewWillAppear = NO;
     
          // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
          // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     /*UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"theNews@2x.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:nil];
     barButton.enabled = false;
     UIBarButtonItem *barButtonTwo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"theNews@2x.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:nil];
     barButtonTwo.enabled = false;
     self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:barButton, barButtonTwo, nil];*/
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width) / 2 - 15, 300, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     [activity startAnimating];
          //Create parallel thread group.
     dispatch_async(dispatch_queue_create("testQueue", DISPATCH_QUEUE_SERIAL), ^{
               //Create parallel thread group.
          dispatch_queue_t parallelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
          dispatch_group_t parallelGroup = dispatch_group_create();
          newsArticles = [[NSMutableArray alloc] init];
          PFQuery *query = [NewsArticleStructure query];
          [query orderByAscending:@"createdAt"];
          query.limit = 10;
          __block NSMutableArray *arrayA = nil;
          __block NSError *errorA = nil;
          dispatch_group_async(parallelGroup, parallelQueue, ^ {
               arrayA = (NSMutableArray *)[query findObjects:&errorA];
          });
          dispatch_group_wait(parallelGroup, DISPATCH_TIME_FOREVER);
          newsArticles = arrayA;
          NSMutableArray *theArray = [newsArticles copy];
          __block NSError *errorB = nil;
          NSMutableArray *theNewsArticleImages = [[NSMutableArray alloc] init];
               NewsArticleStructure *newsArticleStructure;
               for (int i = 0; i < theArray.count; i++) {
                    newsArticleStructure = (NewsArticleStructure *)[theArray objectAtIndex:i];
                    [newsArticleStructure fetchIfNeeded];
                    PFFile *file = newsArticleStructure.imageFile;
                    __block NSData *data;
                    dispatch_group_async(parallelGroup, parallelQueue, ^ {
                        data = [file getData:&errorB];
                         UIImage *image = [UIImage imageWithData:data];
                         image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
                         [theNewsArticleImages addObject:image];
                    });
                    dispatch_group_wait(parallelGroup, DISPATCH_TIME_FOREVER);
                    newsArticleImages = [NSMutableArray arrayWithArray:theNewsArticleImages];
               }
          NSLog(@"We did it!");
     });
     dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
     });
     /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          newsArticleImages = [[NSMutableArray alloc] init];
          newsArticles = [[NSMutableArray alloc] init];
          PFQuery *query = [NewsArticleStructure query];
          [query orderByAscending:@"createdAt"];
          query.limit = 10;
          [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
               if (! error) {
                    newsArticles = (NSMutableArray *)objects;
                    NewsArticleStructure *newsArticleStructure;
                    for (int i = 0; i < newsArticles.count; i++) {
                         newsArticleStructure = (NewsArticleStructure *)[newsArticles objectAtIndex:i];
                         PFFile *file = newsArticleStructure.imageFile;
                         [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                              if (! error) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
                                   [newsArticleImages addObject:image];
                              }
                         }];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                         [activity stopAnimating];
                    });
               }
          }];
     });
     /*[(UIActivityIndicatorView *)object stopAnimating];
     [viewController performSegueWithIdentifier:@"showApplicationSegue" sender:viewController];
     newsArticleImages = [[NSMutableArray alloc] init];
     newsArticles = [[NSMutableArray alloc] init];
     PFQuery *query = [NewsArticleStructure query];
     [query orderByAscending:@"createdAt"];
     query.limit = 10;
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          if (! error) {
               self.newsArticles = (NSMutableArray *)objects;
               NewsArticleStructure *newsArticleStructure;
               for (int i = 0; i < newsArticles.count; i++) {
                    newsArticleStructure = (NewsArticleStructure *)[newsArticles objectAtIndex:i];
                    PFFile *file = newsArticleStructure.imageFile;
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                         if (! error) {
                              UIImage *image = [UIImage imageWithData:data];
                              image = [self imageFromImage:image scaledToWidth:70];
                              [self.newsArticleImages addObject:image];
                         }
                    }];
               }
          }
     }];*/
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
     return newsArticles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 100;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 // Configure the cell...
      NewsArticleStructure *newsArticleStructure = ((NewsArticleStructure *)[newsArticles objectAtIndex:indexPath.row]);
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
      cell.textLabel.text = newsArticleStructure.titleString;
      cell.detailTextLabel.text = newsArticleStructure.summaryString;
      cell.detailTextLabel.numberOfLines = 4;
      if (newsArticleStructure.hasImage == [NSNumber numberWithInt:1])
           cell.imageView.image = (UIImage *)[newsArticleImages objectAtIndex:indexPath.row];
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