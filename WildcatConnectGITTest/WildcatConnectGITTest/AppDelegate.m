//
//  AppDelegate.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ExtracurricularUpdateStructure.h"
#import "CommunityServiceStructure.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     [Parse setApplicationId:@"cLBOvwh6ZTQYex37DSwxL1Cvg34MMiRWYAB4vqs0"
                   clientKey:@"jGjp3WuCzf4ZetH8kpTLGNnj1h3DgtHlCuK1QbTi"];
    /*CommunityServiceStructure *TestOne = [[CommunityServiceStructure alloc] init];
    TestOne.commDateString = @"SampleDate";
    CommunityServiceStructure *TestTwo = [[CommunityServiceStructure alloc] init];
    TestTwo.commPreviewString = @"PreviewCheck";
    CommunityServiceStructure *TestThree = [[CommunityServiceStructure alloc] init];
    TestThree.commSummaryString = @"SummaryCheck";
    CommunityServiceStructure *TestFour = [[CommunityServiceStructure alloc] init];
    TestFour.commTitleString = @"SampleTitle";
    TestOne.IsNewNumber = [NSNumber numberWithInt:1];
    
    [TestOne saveInBackground];
    [TestTwo saveInBackground];
    [TestThree saveInBackground];
    [TestFour saveInBackground];

    //***Image not tested****/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:@"visitedPagesArray"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:@"visitedPagesArray"];
}

@end