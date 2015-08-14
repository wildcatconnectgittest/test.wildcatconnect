//
//  NewsArticleStructure.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "NewsArticleStructure.h"
#import <Parse/PFObject+Subclass.h>

@implementation NewsArticleStructure

     //@dynamic all properties...

@dynamic hasImage; // 0 = false, 1 = true
@dynamic imageFile;
@dynamic titleString;
@dynamic authorString;
@dynamic dateString;
@dynamic contentURLString;
@dynamic articleIDString;
@dynamic likes;

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"NewsArticleStructure";
}

@end
