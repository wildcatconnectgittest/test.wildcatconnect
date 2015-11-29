//
//  AlertStructure.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/8/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "AlertStructure.h"

@implementation AlertStructure

@dynamic titleString;
@dynamic authorString;
@dynamic dateString;
@dynamic contentString;
@dynamic alertID;

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"AlertStructure";
}

@end
