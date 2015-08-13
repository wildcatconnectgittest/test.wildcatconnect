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

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"NewsArticleStructure";
}

@end
