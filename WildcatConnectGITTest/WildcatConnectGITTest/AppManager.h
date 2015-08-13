//
//  AppManager.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppManager : NSObject {
     NSString *testString;
}

@property (nonatomic, retain) NSString *testString;

+ (AppManager *)getInstance;
- (UIImage *)imageFromImage:(UIImage *)sourceImage scaledToWidth:(float)imageWidth;

@end
