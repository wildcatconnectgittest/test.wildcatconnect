//
//  ExtracurricularUpdateStructure.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "ExtracurricularUpdateStructure.h"
#import <Parse/PFObject+Subclass.h>

@implementation ExtracurricularUpdateStructure

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"ExtracurricularUpdateStructure";
}

@end
