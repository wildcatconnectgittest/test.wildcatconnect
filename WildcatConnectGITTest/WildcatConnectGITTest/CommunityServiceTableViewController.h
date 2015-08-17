//
//  CommunityServiceTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityServiceTableViewController : UITableViewController{
    NSMutableArray *allOpps;
    NSMutableArray *commImages;
    NSMutableArray *newOpps;
    NSMutableArray *oldOpps;
    
    
}
@property (nonatomic, retain) NSMutableArray *allOpps;
@property (nonatomic, retain) NSMutableArray *newOpps;
@property (nonatomic, retain) NSMutableArray *oldOpps;
@property (nonatomic, retain) NSMutableArray *commImages;
@end



