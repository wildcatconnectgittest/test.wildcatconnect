//
//  AlertsTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/8/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertsTableViewController : UITableViewController {
     NSMutableArray *alerts;
     NSNumber *loadNumber;
}

@property (nonatomic, retain) NSMutableArray *alerts;
@property (nonatomic, retain) NSNumber *loadNumber;

@end
