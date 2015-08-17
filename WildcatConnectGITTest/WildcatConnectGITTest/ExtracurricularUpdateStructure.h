//
//  ExtracurricularUpdateStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Parse/Parse.h>
#import "ExtracurricularStructure.h"

@interface ExtracurricularUpdateStructure : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

     //Properties...

@property NSString *extracurricularIDString;
@property NSString *messageString;
@property NSString *extracurricularUpdateIDString;

@end
