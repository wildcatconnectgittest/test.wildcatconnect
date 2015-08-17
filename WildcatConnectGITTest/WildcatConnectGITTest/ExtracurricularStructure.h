//
//  ExtracurricularStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>

@interface ExtracurricularStructure : PFObject<PFSubclassing>

+(NSString *)parseClassName;

     //Properties

@property NSString *titleString;
@property NSArray *descriptionString;
@property NSNumber *hasImage;
@property PFFile *imageFile;
@property NSString *meetingString;
@property NSArray *contactInformationArray;
@property NSString *extracurricularIDString;

@end
