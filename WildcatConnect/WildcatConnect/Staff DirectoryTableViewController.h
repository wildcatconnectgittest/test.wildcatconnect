//
//  Staff DirectoryTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Staff_DirectoryTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (nonatomic, strong) UISearchController *searchController;

- (NSArray *)generateSectionsArray;

@end
