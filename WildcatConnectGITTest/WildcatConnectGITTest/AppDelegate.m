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
#import "NewsArticleStructure.h"

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
     
              ExtracurricularUpdateStructure *EC;
     /*@property NSString *titleString;
      @property NSArray *descriptionString;
      @property NSNumber *hasImage;
      @property PFFile *imageFile;
      @property NSString *imageURLString;
      @property NSString *meetingString;
      @property NSDictionary *contactInformationDictionary;
      @property NSString *extracurricularIDString;*/
     /*for (int i = 0; i < 10; i++) {
          EC = [[ExtracurricularUpdateStructure alloc] init];
          EC.extracurricularID = [NSNumber numberWithInt:i];
          EC.messageString = @"sflsjf";
          EC.extracurricularUpdateID = [NSNumber numberWithInt:i];
          [EC saveInBackground];
     }*/
     
     /*ExtracurricularStructure *extracurricularStructure;
     for (int i = 0; i < 10; i++) {
          extracurricularStructure = [[ExtracurricularStructure alloc] init];
          extracurricularStructure.titleString = @"sjflsjf";
          extracurricularStructure.descriptionString = @"descjfs";
          extracurricularStructure.hasImage = [NSNumber numberWithInt:1];
          UIImage *image = [UIImage imageNamed:@"theNews@2x.png"];
          NSData *data = UIImagePNGRepresentation(image);
          PFFile *imageFile = [PFFile fileWithData:data];
          extracurricularStructure.imageFile = imageFile;
          extracurricularStructure.imageURLString = @"sfsdf";
          extracurricularStructure.meetingString = @"jflsjdf";
          extracurricularStructure.contactInformationDictionary = [[NSMutableDictionary alloc] init];
          extracurricularStructure.extracurricularID = [NSNumber numberWithInt:i];
          [extracurricularStructure saveInBackground];
     }*/
     
          //Saving new comm service
     
     /*@property NSString *commTitleString;
      @property NSString *commPreviewString;
      @property NSString *commDateString;
      @property NSString *commSummaryString;
      @property NSNumber *IsNewNumber;
      @property PFFile *commImageFile;
      @property NSNumber *hasImage;
      @property NSNumber *communityServiceID;*/
     
     CommunityServiceStructure *comm;
     for (int i = 0; i < 10; i++) {
          comm = [[CommunityServiceStructure alloc] init];
          comm.commTitleString = @"Test Title";
          comm.commPreviewString = @"sfslfjlsdjf";
          comm.commSummaryString = @"sfjsdfjlsd";
          comm.IsNewNumber = [NSNumber numberWithInt:1];
          NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"home@2x.png"]);
          PFFile *file = [PFFile fileWithData:data];
          comm.commImageFile = file;
          comm.hasImage = [NSNumber numberWithInt:1];
          comm.communityServiceID = [NSNumber numberWithInt:i];
          [comm saveInBackground];
     }
     
          //Saving new news articles...
     
     /*@property NSNumber *hasImage; // 0 = false, 1 = true
      @property PFFile *imageFile;
      @property NSString *titleString;
      @property NSString *summaryString;
      @property NSString *authorString;
      @property NSString *dateString;
      @property NSString *contentURLString;
      @property NSNumber *articleID;
      @property NSNumber *likes;
      @property NSString *imageURLString;*/
     
     /*NewsArticleStructure *news;
     for (int i = 0; i < 5; i++) {
          news = [[NewsArticleStructure alloc] init];
          news.hasImage = [NSNumber numberWithInt:1];
          NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"home@2x.png"]);
          PFFile *file = [PFFile fileWithData:data];
          news.imageFile = file;
          news.titleString = @"Test article...";
          news.summaryString = @"Summary goes here...";
          news.authorString = @"Kevin";
          news.dateString = @"Today!!!";
          news.contentURLString = @"sjflsdjf";
          news.articleID = [NSNumber numberWithInt:i];
          news.likes = [NSNumber numberWithInt:100];
          news.imageURLString = @"sjfsdlsjfsdf";
          [news saveInBackground];
     }*/
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:@"visitedPagesArray"];
     [userDefaults synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:@"visitedPagesArray"];
     [userDefaults synchronize];
}

@end