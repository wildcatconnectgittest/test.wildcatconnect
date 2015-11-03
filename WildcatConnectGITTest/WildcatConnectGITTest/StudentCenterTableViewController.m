//
//  StudentCenterTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "StudentCenterTableViewController.h"

@interface StudentCenterTableViewController ()

@end

@implementation StudentCenterTableViewController{
    UIActivityIndicatorView *activity;
}

    
    
    - (void)viewDidLoad {
        [super viewDidLoad];
        UIRefreshControl *refreshControl= [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        self.refreshControl= refreshControl;
        
        
        /*if (self.loadPollNumber == [NSNumber numberWithInt:1] || ! self.loadPollNumber) {
            [self refreshData];
        }
        else {
            activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [activity setBackgroundColor:[UIColor clearColor]];
            [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
            self.navigationItem.rightBarButtonItem = barButtonItem;
            [activity startAnimating];
            [barButtonItem release];
            [activity startAnimating];
            [self getOldDataWithCompletion:^(NSMutableArray *returnArray) {
                self.polls = returnArray;
                [self getOldImagesWithCompletion:^(NSMutableArray *returnArrayB, NSMutableArray *dataReturnArray) {
                    self.pollImages = returnArrayB;
                    self.pollDataArray = dataReturnArray;
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self.tableView reloadData];
                        [activity stopAnimating];
                        [self refreshControl];
                    });
                }];
            }];
        }*/
    }
    
    - (void)refresh {
        [self refreshData];
        [self.refreshControl endRefreshing];
    }









    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber {
    [super init];
    self.loadPollNumber = theLoadNumber;
    self.navigationItem.title = @"Student Center";
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
