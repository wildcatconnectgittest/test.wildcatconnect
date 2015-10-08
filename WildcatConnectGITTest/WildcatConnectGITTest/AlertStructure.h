//
//  AlertStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/8/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AlertStructure : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *titleString;
@property NSString *authorString;
@property NSString *dateString;
@property NSString *contentString; //could change depending on future web structure...

@end
