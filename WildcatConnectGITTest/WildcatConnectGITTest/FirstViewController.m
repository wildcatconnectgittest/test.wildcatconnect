//
//  FirstViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>
#import "NewsArticleStructure.h"
#import "ExtracurricularUpdateStructure.h"
#import "AppManager.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [scrollerhome setScrollEnabled:YES];
    [scrollerhome setContentSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width, 1000)];
    CGSize ScreenSize = [[UIScreen mainScreen] bounds].size;
    self.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
     [self getCountMethodWithCompletion:^(NSInteger count) {
          NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"];
          NSInteger read = array.count;
          NSNumber *number = [NSNumber numberWithInt:(count - read)];
          [self getCountTwoMethodWithCompletion:^(NSInteger count2) {
               NSNumber *updates = [NSNumber numberWithInt:count2];;
               NSInteger final = [number integerValue] + [updates integerValue];
               if (final > 0) {
                    [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[NSNumber numberWithInt:final] stringValue];
               }
               else
                    [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
          }];
          
     }];
}

- (void)getCountTwoMethodWithCompletion:(void (^)(NSInteger count))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFQuery *query = [ExtracurricularUpdateStructure query];
     __block int count;
     [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
          count = number;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(count);
     });
}

- (void)getCountMethodWithCompletion:(void (^)(NSInteger count))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFQuery *query = [NewsArticleStructure query];
     __block int count;
     [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
          count = number;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(count);
     });
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
