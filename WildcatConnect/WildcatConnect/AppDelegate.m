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
#import "LunchMenusStructure.h"
#import "UsefulLinkArray.h"
#import "AlertStructure.h"
#import "PollStructure.h"
#import "SchoolDayStructure.h"
#import "ScheduleType.h"
#import "AlertDetailViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     
     [Parse setApplicationId:@"cLBOvwh6ZTQYex37DSwxL1Cvg34MMiRWYAB4vqs0"
                   clientKey:@"jGjp3WuCzf4ZetH8kpTLGNnj1h3DgtHlCuK1QbTi"];
     
     
     
     [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
     
     UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                     UIUserNotificationTypeBadge |
                                                     UIUserNotificationTypeSound);
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                              categories:nil];
     
     if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
     {
               // iOS 8 Notifications
          [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
          
          [application registerForRemoteNotifications];
     }
     else
     {
               // iOS < 8 Notifications
          [application registerForRemoteNotificationTypes:
           (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
     }
     
     NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
     
     if (notificationPayload) {
          self.alertString = [notificationPayload objectForKey:@"a"];
          [self getAlertForIDMethodWithCompletion:^(NSMutableArray *array, NSError *error) {
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reloadAlertsPage"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSMutableArray *readArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"readAlerts"] mutableCopy];
                    if (! readArray) {
                         readArray = [[NSMutableArray alloc] init];
                    }
                    [readArray addObject:self.alertString];
                    [[NSUserDefaults standardUserDefaults] setObject:readArray forKey:@"readAlerts"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    AlertStructure *theAlert = [[AlertStructure alloc] init];
                    theAlert.titleString = [[array firstObject] objectForKey:@"titleString"];
                    theAlert.authorString = [[array firstObject] objectForKey:@"authorString"];
                    theAlert.alertTime = [[array firstObject] objectForKey:@"alertTime"];
                    theAlert.contentString = [[array firstObject] objectForKey:@"contentString"];
                    theAlert.hasTime = [[array firstObject] objectForKey:@"hasTime"];
                    theAlert.dateString = [[array firstObject] objectForKey:@"dateString"];
                    AlertDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertDetail"];
                    controller.alert = theAlert;
                    controller.showCloseButton = YES;
                    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                    UINavigationController *navigationController =
                    [[UINavigationController alloc] initWithRootViewController:controller];
                    [nav presentViewController:navigationController animated:YES completion:^{}];
               });
          } forID:self.alertString];
     }
     
     if (application.applicationState != UIApplicationStateBackground) {
               // Track an app open here if we launch with a push, unless
               // "content_available" was used to trigger a background push (introduced
               // in iOS 7). In that case, we skip tracking here to avoid double
               // counting the app-open.
          BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
          BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
          BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
          if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
               [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
          }
     }
     
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
     
     /*CommunityServiceStructure *comm;
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
     
     /*UsefulLinkArray *districtPagesArray = [[UsefulLinkArray alloc] init];
     NSMutableArray *arrayOne = [[NSMutableArray alloc] init];
     districtPagesArray.headerTitle = @"DISTRICT PAGES";
     districtPagesArray.index = [NSNumber numberWithInt:0];
     arrayOne = [[NSMutableArray alloc] init];
     NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"Weymouth Public Schools Website" forKey:@"titleString"];
     [dictionary setValue:@"http://www.weymouthschools.org" forKey:@"URLString"];
     [arrayOne addObject:dictionary];
     dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"Weymouth High School Website" forKey:@"titleString"];
     [dictionary setValue:@"http://www.weymouthschools.org/weymouth-high-school" forKey:@"URLString"];
     [arrayOne addObject:dictionary];
     districtPagesArray.linksArray = [arrayOne copy];
     [districtPagesArray saveInBackground];
     
     UsefulLinkArray *studentLoginsArray = [[UsefulLinkArray alloc] init];
     NSMutableArray *arrayTwo = [[NSMutableArray alloc] init];
     studentLoginsArray.headerTitle = @"STUDENT LOGINS";
     studentLoginsArray.index = [NSNumber numberWithInt:1];
     dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"X2 Portal" forKey:@"titleString"];
     [dictionary setValue:@"https://x2.weymouthschools.org/x2sis/logon.do" forKey:@"URLString"];
     [arrayTwo addObject:dictionary];
     dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"Student Webmail (Grades 11-12)" forKey:@"titleString"];
     [dictionary setValue:@"http://mail.weymouthstudents.org" forKey:@"URLString"];
     [arrayTwo addObject:dictionary];
     dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"Student Webmail (Grades 9-10)" forKey:@"titleString"];
     [dictionary setValue:@"https://accounts.google.com/Login" forKey:@"URLString"];
     [arrayTwo addObject:dictionary];
     dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"Naviance" forKey:@"titleString"];
     [dictionary setValue:@"https://connection.naviance.com/family-connection/auth/login/?hsid=weymouth" forKey:@"URLString"];
     [arrayTwo addObject:dictionary];
     studentLoginsArray.linksArray = [arrayTwo copy];
     [studentLoginsArray saveInBackground];*/
     
     /*LunchMenusStructure *lunch;
     for (int i = 0; i < 5; i++) {
          lunch = [[LunchMenusStructure alloc] init];
          lunch.breakfastString = @"Breakfast!";
          lunch.lunchString = @"Lunch!";
          lunch.dateString = @"Monday, September 14th";
          lunch.lunchStructureID = [NSNumber numberWithInt:i];
          [lunch saveInBackground];
     }*/
     
          //[PFUser logOutInBackground];
     
     /*AlertStructure *alertStructure = [[AlertStructure alloc] init];
     alertStructure.titleString = @"Test Alert";
     alertStructure.authorString = @"Kevin Lyons";
     alertStructure.dateString = @"Thursday, October 8th, 2015";
     alertStructure.contentString = @"This is a test content string for this alert!";
     [alertStructure saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
          if (! error) {
               NSLog(@"Here!!! Saved successfully without error.");
          }
     }];*/
     
          //[PFUser logOutInBackground];
     
     /*PollStructure *pollStructure = [[PollStructure alloc] init];
     pollStructure.pollTitle = @"Cell Phone Policy";
     pollStructure.pollQuestion = @"Do you think that students should be able to use cell phones in class all the time?";
     pollStructure.pollMultipleChoices = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"0", @"0", nil] forKeys:[NSArray arrayWithObjects:@"YES", @"NO", nil]];
     pollStructure.pollID = @"0";
     pollStructure.totalResponses = @"0";
     [pollStructure saveInBackground];*/
     
     /*SchoolDayStructure *schoolDayStructure = [[SchoolDayStructure alloc] init];
     schoolDayStructure.schoolDayID = @"0";
     schoolDayStructure.schoolDate = @"11-23-2015";
     schoolDayStructure.scheduleType = @"D";
     schoolDayStructure.messageString = @"No major events today.";
     schoolDayStructure.hasImage = YES;
     UIImage *image = [UIImage imageNamed:@"studentCenter@2x.png"];
     NSData *data = UIImagePNGRepresentation(image);
     schoolDayStructure.imageFile = [PFFile fileWithData:data];
     schoolDayStructure.imageString = @"None.";
     [schoolDayStructure saveInBackground];*/
     
     
     /*ScheduleType *scheduleType = [[ScheduleType alloc] init];
     scheduleType.typeID = @"F1";
     scheduleType.scheduleString = @"To be copied.";
     scheduleType.alertNeeded = YES;
     [scheduleType saveInBackground];*/
     
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     PFInstallation *currentInstallation = [PFInstallation currentInstallation];
     [currentInstallation setDeviceTokenFromData:deviceToken];
     currentInstallation.channels = @[ @"global" ];
     [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
     if (error.code == 3010) {
               //
     } else {
               //
     }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     if (buttonIndex == 0) {
          [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reloadAlertsPage"];
          [[NSUserDefaults standardUserDefaults] synchronize];
     } else {
          [self getAlertForIDMethodWithCompletion:^(NSMutableArray *array, NSError *error) {
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reloadAlertsPage"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSMutableArray *readArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"readAlerts"] mutableCopy];
                    if (! readArray) {
                         readArray = [[NSMutableArray alloc] init];
                    }
                    [readArray addObject:self.alertString];
                    [[NSUserDefaults standardUserDefaults] setObject:readArray forKey:@"readAlerts"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    AlertStructure *theAlert = [[AlertStructure alloc] init];
                    theAlert.titleString = [[array firstObject] objectForKey:@"titleString"];
                    theAlert.authorString = [[array firstObject] objectForKey:@"authorString"];
                    theAlert.alertTime = [[array firstObject] objectForKey:@"alertTime"];
                    theAlert.contentString = [[array firstObject] objectForKey:@"contentString"];
                    theAlert.hasTime = [[array firstObject] objectForKey:@"hasTime"];
                    theAlert.dateString = [[array firstObject] objectForKey:@"dateString"];
                    AlertDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertDetail"];
                    controller.alert = theAlert;
                    controller.showCloseButton = YES;
                    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                    UINavigationController *navigationController =
                    [[UINavigationController alloc] initWithRootViewController:controller];
                    [nav presentViewController:navigationController animated:YES completion:^{}];
               });
          } forID:self.alertString];
     }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
     self.alertString = [userInfo objectForKey:@"a"];
     if (self.alertString) {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have 1 new alert message. Would you like to read now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
          [alert show];
     }
     if (application.applicationState == UIApplicationStateInactive) {
               // The application was just brought from the background to the foreground,
               // so we consider the app as having been "opened by a push notification."
          [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
     }
}

- (void)getAlertForIDMethodWithCompletion:(void (^)(NSMutableArray *array, NSError *error))completion forID:(NSString *)IDString {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *array = [NSMutableArray array];
     PFQuery *query = [AlertStructure query];
     [query whereKey:@"alertID" equalTo:IDString];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
          theError = error;
          [array addObject:object];
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError) {
               overallError = theError;
          }
          completion(array, overallError);
     });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     PFInstallation *currentInstallation = [PFInstallation currentInstallation];
     if (currentInstallation.badge != 0) {
          currentInstallation.badge = 0;
          [currentInstallation saveEventually];
     }
}

- (void)applicationWillResignActive:(UIApplication *)application {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:@"reloadHomePage"]; // keep this
     [userDefaults synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:@"reloadHomePage"]; // keep this
     [userDefaults synchronize];
}

@end