//
//  PollStructure.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "PollStructure.h"
#import <Parse/PFObject+Subclass.h>

@implementation PollStructure

@dynamic choice;
@dynamic pollTitleString;
@dynamic pollDate;
@dynamic infoString;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"pollStructure";
}



@end
