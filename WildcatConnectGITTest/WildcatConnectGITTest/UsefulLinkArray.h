//
//  UsefulLinkArray.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 9/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface UsefulLinkArray : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property NSMutableArray *linksArray;
@property NSString *headerTitle;

@end
