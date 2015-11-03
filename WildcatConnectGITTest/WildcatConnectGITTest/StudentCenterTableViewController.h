//
//  StudentCenterTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentCenterTableViewController : UITableViewController
{
    NSMutableArray *polls;
    NSMutableArray *pollOptions;
    NSMutableArray *pollDate;
    NSMutableArray *pollsCompleted;
    NSNumber *loadPollNumber;
    NSMutableArray *pollImages;
    NSMutableArray *pollDataArray;
    NSMutableArray *pollUpdatesArray;
    
    
    
}
@property (nonatomic, retain) NSMutableArray *pollOptions;
@property (nonatomic, retain) NSMutableArray *pollDate;
@property (nonatomic, retain) NSMutableArray *pollsCompleted;
@property (nonatomic, retain) NSNumber *loadPollNumber;
@property (nonatomic, retain) NSMutableArray *pollImages;
@property (nonatomic, retain) NSMutableArray *pollDataArray;
@property (nonatomic, retain) NSMutableArray *polls;
@property (nonatomic, retain) NSMutableArray *pollUpdatesArray;


@end
