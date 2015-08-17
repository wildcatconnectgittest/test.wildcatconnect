//
//  CommunityServiceStructure.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "CommunityServiceStructure.h"
#import <Parse/PFObject+Subclass.h>

@implementation CommunityServiceStructure

@dynamic commDateString;
@dynamic commPreviewString;
@dynamic commSummaryString;
@dynamic commTitleString;
@dynamic IsNewNumber;
@dynamic commImageFile;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"CommunityServiceStructure";
}

@end
