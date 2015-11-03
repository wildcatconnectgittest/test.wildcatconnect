//
//  StudentCenterTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentCenterTableViewController : UITableViewController {
     NSNumber *loadNumber;
}

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber;

@property (nonatomic, retain) NSNumber *loadNumber;

@end
