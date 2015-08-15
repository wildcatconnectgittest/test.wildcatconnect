//
//  StaffDirectoryMainTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/14/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "StaffDirectoryMainTableViewController.h"
#import "StaffDirectoryResultsTableViewController.h"
#import "StaffDirectoryDetailViewController.h"
#import "StaffMemberStructure.h"
#import "AppManager.h"
#import "ApplicationManager.h"

@interface StaffDirectoryMainTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) StaffDirectoryResultsTableViewController *resultsTableController;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation StaffDirectoryMainTableViewController {
     NSArray *dictionaryArray;
     NSArray *staffMembers;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     _resultsTableController = [[StaffDirectoryResultsTableViewController alloc] init];
     _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
     self.searchController.searchResultsUpdater = self;
     [self.searchController.searchBar sizeToFit];
     self.tableView.tableHeaderView = self.searchController.searchBar;
     
     // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
     
     self.resultsTableController.tableView.delegate = self;
     self.searchController.delegate = self;
     self.searchController.dimsBackgroundDuringPresentation = NO;
     self.searchController.searchBar.delegate = self;
     
          // Search is now just presenting a view controller. As such, normal view controller
          // presentation semantics apply. Namely that presentation will walk up the view controller
          // hierarchy until it finds the root view controller or one that defines a presentation context.
          //
     
     self.definesPresentationContext = YES;
     staffMembers = [[AppManager getInstance] getStaffMembers];
     dictionaryArray = [self generateSectionsArray];
     ApplicationManager *applicationManager = [ApplicationManager sharedManager];
     [applicationManager loadStaffMembers];
     NSLog(@"%lu", (unsigned long)applicationManager.staffMembers.count);
}

- (NSArray *)generateSectionsArray {
     NSMutableArray *currentArrayLeft = (NSMutableArray *)staffMembers;
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

- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
     
          // restore the searchController's active state
     if (self.searchControllerWasActive) {
          self.searchController.active = self.searchControllerWasActive;
          _searchControllerWasActive = NO;
          
          if (self.searchControllerSearchFieldWasFirstResponder) {
               [self.searchController.searchBar becomeFirstResponder];
               _searchControllerSearchFieldWasFirstResponder = NO;
          }
     }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

     // Called after the search controller's search bar has agreed to begin editing or when
     // 'active' is set to YES.
     // If you choose not to present the controller yourself or do not implement this method,
     // a default presentation is performed on your behalf.
     //
     // Implement this method if the default presentation is not adequate for your purposes.
     //
- (void)presentSearchController:(UISearchController *)searchController {
     
}

- (void)willPresentSearchController:(UISearchController *)searchController {
          // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
          // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
          // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
          // do something after the search controller is dismissed
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
          // Return the number of sections.
          return [dictionaryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
          // Return the number of rows in the section.else
          return ((NSArray *)[[dictionaryArray objectAtIndex:section] objectForKey:@"rowValues"]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
     if (! cell) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
               // More initializations if needed.
     }
     NSArray *array = ((NSArray *)[[dictionaryArray objectAtIndex:[indexPath section] ] objectForKey:@"rowValues"]);
     StaffMemberStructure *staffMemberStructure = (tableView == self.tableView) ? array[indexPath.row] : self.resultsTableController.filteredStaffMembers[indexPath.row];
     [self configureCell:cell forStaffMemberStructure:staffMemberStructure];
     return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
     if (self.tableView != tableView) {
          return nil;
     } else {
          
          NSMutableArray *array = [[NSMutableArray alloc] init];
          for (char a = 'A'; a <= 'Z'; a++)
          {
               [array addObject:[NSString stringWithFormat:@"%c", a]];
          }
          return [NSArray arrayWithArray:array];
     }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
     return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if (tableView == self.tableView)
          return [[dictionaryArray objectAtIndex:section] objectForKey:@"headerTitle"];
     else
          return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSArray *array = [[dictionaryArray objectAtIndex:[indexPath section]] objectForKey:@"rowValues"];
     StaffMemberStructure *selectedStaffMemberStructure = (tableView == self.tableView) ? array[indexPath.row] : self.resultsTableController.filteredStaffMembers[indexPath.row];
     
     StaffDirectoryDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StaffDirectoryDetailViewController"];
     detailViewController.staffMemberStructure = selectedStaffMemberStructure;
     
     [self.navigationController pushViewController:detailViewController animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
          //udpate the filtered array based on the search text
     NSString *searchText = searchController.searchBar.text;
     NSMutableArray *searchResults = [staffMembers mutableCopy];
          //strip out all the leading and trailing spaces
     NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
          //break up the search terms (separated by spaces)
     NSArray *searchItems = nil;
     if (strippedString.length > 0) {
          searchItems = [strippedString componentsSeparatedByString:@" "];
     }
          //build all the "AND" expressions for each value in the search string
     NSMutableArray *andMatchPredicates = [NSMutableArray array];
     for (NSString *searchString in searchItems) {
               //each searchString creates an OR predicate for: lastName, firstName, title
          NSMutableArray *searchItemsPredicate = [NSMutableArray array];
               //Below we use NSExpression to represent expressions in our predicates.
               //Last name field matching
          NSExpression *lhs = [NSExpression expressionForKeyPath:@"staffMemberLastName"];
          NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
          NSPredicate *finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSDirectPredicateModifier type:NSBeginsWithPredicateOperatorType options:NSCaseInsensitivePredicateOption];
          [searchItemsPredicate addObject:finalPredicate];
               //First name field matching
          lhs = [NSExpression expressionForKeyPath:@"staffMemberFirstName"];
          rhs = [NSExpression expressionForConstantValue:searchString];
          finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSDirectPredicateModifier type:NSBeginsWithPredicateOperatorType options:NSCaseInsensitivePredicateOption];
          [searchItemsPredicate addObject:finalPredicate];
               //Title field matching
          lhs = [NSExpression expressionForKeyPath:@"staffMemberTitle"];
          rhs = [NSExpression expressionForConstantValue:searchString];
          finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSDirectPredicateModifier type:NSContainsPredicateOperatorType options:NSCaseInsensitivePredicateOption];
          [searchItemsPredicate addObject:finalPredicate];
               //add this OR predicate to our master AND predicate
          NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
          [andMatchPredicates addObject:orMatchPredicates];
     }
          //match up the fields of the StaffMemberStructure object
     NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
     searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
          //hand over the filtered results to our search results table
     StaffDirectoryResultsTableViewController *tableController = (StaffDirectoryResultsTableViewController *)self.searchController.searchResultsController;
     tableController.filteredStaffMembers = searchResults;
     [tableController.tableView reloadData];
}

#pragma mark - UIStateRestoration

     // we restore several items for state restoration:
     //  1) Search controller's active state,
     //  2) search text,
     //  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
     [super encodeRestorableStateWithCoder:coder];
          //encode the view state so it can be restored later
          //encode the title
     [coder encodeObject:self.title forKey:ViewControllerTitleKey];
     UISearchController *searchController = self.searchController;
          //encode the searchController's active state
     BOOL searchDisplayControllerIsActive = searchController.isActive;
     [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
          //encode the first responder status
     if (searchDisplayControllerIsActive) {
          [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
     }
          //encode the search bar text
     [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
     [super decodeRestorableStateWithCoder:coder];
          //restore the title
     self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
          //restore the active state
          //we cna't make the searchController active here since it's not part of the view hierarchy yet, instead we will do it in viewWillAppear
     _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
          //restore the first responder status
     _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
          //restore the text in the search text field
     self.searchController.searchBar.text  = [coder decodeObjectForKey:SearchBarTextKey];
}

@end
