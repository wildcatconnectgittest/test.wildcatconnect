//
//  TestStructure.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestStructure : NSObject

@property (nonatomic, strong) NSString *testStructureName;
@property (nonatomic, strong) NSMutableArray *testStructureMutableArray;

- (void)printTestStructure;

@end
