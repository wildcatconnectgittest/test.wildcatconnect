//
//  NewsArticleStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface NewsArticleStructure : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

     //Properties

@property NSNumber *hasImage; // 0 = false, 1 = true
@property NSString *imageURLString;
@property NSString *titleString;
@property NSString *authorString;
@property NSString *dateString;
@property NSString *contentURLString;
@property NSNumber *likes;

@end
