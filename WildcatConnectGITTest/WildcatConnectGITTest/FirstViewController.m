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
#import "PollStructure.h"
#import "AppManager.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
     UIScrollView *scrollView;
     UILabel *titleLabelA;
     UILabel *titleLabelB;
     UILabel *titleLabelC;
}

- (void)viewDidLoad {
	[super viewDidLoad];
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     self.navigationController.navigationItem.title = @"Home";
     
     scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     titleLabelA = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
     titleLabelA.text = @"Today is...";
     [titleLabelA setFont:[UIFont systemFontOfSize:12]];
     titleLabelA.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabelA.numberOfLines = 0;
     [titleLabelA sizeToFit];
     [scrollView addSubview:titleLabelA];
     
     titleLabelB = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabelA.frame.origin.y + titleLabelA.frame.size.height + 5, 0, 0)];
     NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
     [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
     [dateFormatter setDateFormat:@"EEEE"];
     NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
     titleLabelB.text = [currentDate stringByAppendingString:@","];
     [titleLabelB setFont:[UIFont systemFontOfSize:32]];
     titleLabelB.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabelB.numberOfLines = 0;
     [titleLabelB sizeToFit];
     [scrollView addSubview:titleLabelB];
     
     titleLabelC = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabelB.frame.origin.y + titleLabelB.frame.size.height, 0, 0)];
     [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
     currentDate = [dateFormatter stringFromDate:[NSDate date]];
     titleLabelC.text = currentDate;
     [titleLabelC setFont:[UIFont systemFontOfSize:32]];
     titleLabelC.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabelC.numberOfLines = 0;
     [titleLabelC sizeToFit];
     [scrollView addSubview:titleLabelC];
     
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     self.automaticallyAdjustsScrollViewInsets = YES;
     UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 70, 0);
     scrollView.contentInset = adjustForTabbarInsets;
     scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
     [self.view addSubview:scrollView];
     
     [self getCountMethodWithCompletion:^(NSInteger count) {
          NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"];
          NSInteger read = array.count;
          NSNumber *number = [NSNumber numberWithInt:(count - read)];
          [self getCountTwoMethodWithCompletion:^(NSInteger count2) {
               NSNumber *updates = [NSNumber numberWithInt:count2];;
               [self getCountThreeMethodWithCompletion:^(NSInteger count3) {
                    NSMutableArray *SCarray = [[NSUserDefaults standardUserDefaults] objectForKey:@"answeredPolls"];
                    NSInteger answered = SCarray.count;
                    NSNumber *secondNumber = [NSNumber numberWithInt:(count3 - answered)];
                    NSInteger final = [number integerValue] + [updates integerValue] + [secondNumber integerValue];
                    if (final > 0) {
                         [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[NSNumber numberWithInt:final] stringValue];
                    }
                    else
                         [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
               }];
          }];
          
     }];
}

- (void)getCountThreeMethodWithCompletion:(void (^)(NSInteger count))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFQuery *query = [PollStructure query];
     __block int count;
     [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
          count = number;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(count);
     });
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
