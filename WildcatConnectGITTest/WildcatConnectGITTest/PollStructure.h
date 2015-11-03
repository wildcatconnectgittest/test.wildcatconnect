//
//  PollStructure.h
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface PollStructure : PFObject<PFSubclassing>


+ (NSString *)parseClassName;

@property NSNumber *choice; // 0= yes/no 1 = mc 2 = response
@property NSString *pollTitleString;
@property NSString *pollDate;
@property NSString *infoString;


@end
