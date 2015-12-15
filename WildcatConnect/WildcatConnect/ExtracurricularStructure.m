//
//  ExtracurricularStructure.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "ExtracurricularStructure.h"
#import <Parse/PFObject+Subclass.h>

@implementation ExtracurricularStructure

     //@dynamic all properties...

@dynamic titleString;
@dynamic descriptionString;
@dynamic hasImage;
@dynamic imageFile;
@dynamic imageURLString;
@dynamic extracurricularID;
@dynamic meetingIDs;
@dynamic channelString;

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"ExtracurricularStructure";
}

@end
