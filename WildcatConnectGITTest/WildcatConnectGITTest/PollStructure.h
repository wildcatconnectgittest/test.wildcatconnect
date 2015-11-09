//
//  PollStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/8/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface PollStructure : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *pollTitle;
@property NSString *pollQuestion;
@property NSNumber *pollType; // 0 = Y/N, 1 = MULTIPLE CHOICE
@property NSArray *pollMultipleChoices; // Array of strings...
@property NSNumber *pollID;

@end
