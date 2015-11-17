//
//  SchoolDayStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/14/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface SchoolDayStructure : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *schoolDayID;
@property NSString *schoolDate; // MM/dd/yyyy
@property NSString *scheduleType;
@property NSString *messageString;
@property BOOL hasImage;
@property PFFile *imageFile;
@property NSString *imageString;
@property NSString *imageUser;
@property NSString *customSchedule;

@end
