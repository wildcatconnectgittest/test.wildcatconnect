//
//  ScheduleType.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/15/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "ScheduleType.h"

@implementation ScheduleType

@dynamic typeID;
@dynamic scheduleString;
@dynamic alertNeeded;

+ (void)load {
     [self registerSubclass];
}

+ (NSString *)parseClassName {
     return @"ScheduleType";
}

- (NSString *)getFullScheduleString {
     if ([self.typeID isEqual:@"D"]) {
          return @"Day D";
     } else if ([self.typeID isEqual:@"E"]) {
          return @"Day E";
     } else if ([self.typeID  isEqual: @"F1"]) {
          return @"Day F, HR after 1st Period";
     } else if ([self.typeID isEqual:@"G"]) {
          return @"Day G";
     } else if ([self.typeID isEqual:@"G1"]) {
          return @"Day G, HR after 1st Period";
     }else return nil;
}

@end
