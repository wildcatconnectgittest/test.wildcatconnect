//
//  Staff DirectoryTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "Staff DirectoryTableViewController.h"
#import "AppManager.h"
#import "StaffMemberStructure.h"

@interface Staff_DirectoryTableViewController ()

@end

@implementation Staff_DirectoryTableViewController {
     AppManager *manager;
     NSArray *dictionaryArray;
     BOOL isSearching;
}

@synthesize resultsArray;
@synthesize searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     manager = [AppManager getInstance];
     dictionaryArray = [self generateSectionsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
          return [dictionaryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.else
          return ((NSArray *)[[dictionaryArray objectAtIndex:section] objectForKey:@"rowValues"]).count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
     NSMutableArray *array = [[NSMutableArray alloc] init];
     for (char a = 'A'; a <= 'Z'; a++)
     {
          [array addObject:[NSString stringWithFormat:@"%c", a]];
     }
     return [NSArray arrayWithArray:array];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
     return index;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
     return [[dictionaryArray objectAtIndex:section] objectForKey:@"headerTitle"];
     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
          NSDictionary *dictionary = (NSDictionary *)[dictionaryArray objectAtIndex:[indexPath section]];
          NSArray *array = [dictionary objectForKey:@"rowValues"];
          StaffMemberStructure *staffMemberStructure = [array objectAtIndex:[indexPath row]];
          cell.textLabel.text = [staffMemberStructure fullNameCommaString];
          cell.detailTextLabel.text = staffMemberStructure.staffMemberTitle;
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

- (NSArray *)generateSectionsArray {
     NSMutableArray *currentArrayLeft = manager.staffMembers;
     NSMutableArray *array = [NSMutableArray new];
     for (char a = 'A'; a <= 'Z'; a++) {
          NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
          NSMutableArray *words = [[[NSMutableArray alloc] init] autorelease];
          StaffMemberStructure *staffMemberStructure;
          for (int i = 0; i < currentArrayLeft.count; i++) {
               staffMemberStructure = [currentArrayLeft objectAtIndex:i];
               if ([[staffMemberStructure.staffMemberLastName substringToIndex:1] isEqualToString:[NSString stringWithFormat:@"%c", a]]) {
                    [words addObject:staffMemberStructure];
                    [currentArrayLeft removeObjectAtIndex:i];
               }
          }
          [row setValue:words forKey:@"rowValues"];
          [row setValue:[NSString stringWithFormat:@"%c", a] forKey:@"headerTitle"];
          [array addObject:row];
     }
     return array;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
     [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
     NSString *searchString = searchController.searchBar.text;
     [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
     [self.tableView reloadData];
}

@end
