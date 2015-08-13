//
//  AppManager.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

@synthesize testString;

static AppManager *instance = nil;

+ (AppManager *)getInstance {
     @synchronized(self) {
          if (instance == nil) {
               instance = [AppManager new];
          }
     }
     return instance;
}

- (UIImage *)imageFromImage:(UIImage *)sourceImage scaledToWidth:(float)imageWidth {
     float oldWidth = sourceImage.size.width;
     float scaleFactor = imageWidth / oldWidth;
     float newHeight = sourceImage.size.height * scaleFactor;
     float newWidth = oldWidth * scaleFactor;
     UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
     [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     return newImage;
}

@end
