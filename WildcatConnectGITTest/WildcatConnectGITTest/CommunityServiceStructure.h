//
//  CommunityServiceStructure.h
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface CommunityServiceStructure : PFObject<PFSubclassing>

//properties

+ (NSString *)parseClassName;

@property NSString *commTitleString;
@property NSDate *startDate;
@property NSDate *endDate;
@property NSString *commSummaryString;
@property NSNumber *IsNewNumber;
@property NSNumber *communityServiceID;
//0=no, old 1 = yes, new
@end
