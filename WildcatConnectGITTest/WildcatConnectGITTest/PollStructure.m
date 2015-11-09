//
//  PollStructure.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/8/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "PollStructure.h"
#import <Parse/PFObject+Subclass.h>

@implementation PollStructure

@dynamic pollTitle;
@dynamic pollQuestion;
@dynamic pollType;
@dynamic pollMultipleChoices;

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"PollStructure";
}

@end
