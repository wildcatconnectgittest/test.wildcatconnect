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
#import "SchoolDayStructure.h"
#import "ScheduleType.h"
#import "AlertStructure.h"
#import "LunchMenusStructure.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
     UIScrollView *scrollView;
     UILabel *titleLabelA;
     UILabel *titleLabelB;
     UILabel *titleLabelC;
     SchoolDayStructure *schoolDay;
     ScheduleType *scheduleType;
     UILabel *dayLabel;
     UIActivityIndicatorView *activity;
     UILabel *scheduleLabel;
     UILabel *messageLabelA;
     UITextView *messageLabelB;
     UILabel *lunchLabelA;
     UITextView *lunchLabelB;
     NSData *imageData;
     UILabel *imageLabel;
     UITextView *imageLabelB;
     NSNumber *hasImage;
     NSString *breakfastString;
     NSString *lunchString;
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     self.navigationController.navigationItem.title = @"Home";
     
     NSString *loadString = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloadHomePage"];
     if (! loadString || [loadString isEqual:@"1"]) {
          [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"reloadHomePage"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          self.navigationController.navigationBar.translucent = NO;
          
          activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
          [activity setBackgroundColor:[UIColor clearColor]];
          [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
          UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
          self.navigationItem.rightBarButtonItem = barButtonItem;
          [activity startAnimating];
          [barButtonItem release];
          
          schoolDay = [[SchoolDayStructure alloc] init];
          scheduleType = [[ScheduleType alloc] init];
          imageData = [NSData data];
          
          breakfastString = [[NSString alloc] init];
          lunchString = [[NSString alloc] init];
          
          if (scrollView) {
               [scrollView removeFromSuperview];
          }
          
          scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
          
          [self getCurrentLunchMethodWithCompletion:^(NSError *error, NSMutableArray *theLunch) {
               if (error != nil) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Error fetching data from server. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                    dispatch_async(dispatch_get_main_queue(), ^ {
                         [activity stopAnimating];
                         UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewWillAppear:)];
                         self.navigationItem.rightBarButtonItem = barButtonItem;
                         [activity startAnimating];
                         [barButtonItem release];
                    });
               } else {
                    breakfastString = [[theLunch objectAtIndex:0] objectForKey:@"breakfastString"];
                    lunchString = [[theLunch objectAtIndex:0] objectForKey:@"breakfastString"];
                    [self getCurrentSchoolDayMethodWithCompletion:^(NSError *error, NSMutableArray *theDay, NSString *bString, NSString *lString) {
                         if (error != nil) {
                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Error fetching data from server. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                              [alertView show];
                              dispatch_async(dispatch_get_main_queue(), ^ {
                                   [activity stopAnimating];
                                   UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewWillAppear:)];
                                   self.navigationItem.rightBarButtonItem = barButtonItem;
                                   [activity startAnimating];
                                   [barButtonItem release];
                              });
                         } else {
                              schoolDay.schoolDate = [[theDay objectAtIndex:0] objectForKey:@"schoolDate"];
                              hasImage = [[theDay objectAtIndex:0] objectForKey:@"hasImage"];
                              schoolDay.imageFile = [[theDay objectAtIndex:0] objectForKey:@"imageFile"];
                              schoolDay.imageString = [[theDay objectAtIndex:0] objectForKey:@"imageString"];
                              schoolDay.messageString = [[theDay objectAtIndex:0] objectForKey:@"messageString"];
                              schoolDay.scheduleType = [[theDay objectAtIndex:0] objectForKey:@"scheduleType"];
                              schoolDay.schoolDayID = [[theDay objectAtIndex:0] objectForKey:@"schoolDayID"];
                              schoolDay.customSchedule = [[theDay objectAtIndex:0] objectForKey:@"customSchedule"];
                              if ([schoolDay.scheduleType isEqual:@"*"]) {
                                   
                                   titleLabelB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
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
                                   
                                   UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabelC.frame.origin.y + titleLabelC.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                   separator.backgroundColor = [UIColor blackColor];
                                   [scrollView addSubview:separator];
                                   
                                   dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                   NSDateFormatter* day = [[NSDateFormatter alloc] init];
                                   [day setDateFormat: @"EEEE"];
                                   NSString *today = [day stringFromDate:[NSDate date]];
                                   dateFormatter = [[NSDateFormatter alloc] init];
                                        // this is imporant - we set our input date format to match our input string
                                        // if format doesn't match you'll get nil from your string, so be careful
                                   [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                                   NSDate *dateFromString = [[NSDate alloc] init];
                                        // voila!
                                   dateFromString = [dateFormatter dateFromString:schoolDay.schoolDate];
                                   NSString *actual = [day stringFromDate:dateFromString];
                                   if ([today isEqualToString:actual]) {
                                        dayLabel.text = @"Today is a custom schedule.";
                                   } else {
                                        dayLabel.text = [actual stringByAppendingString:@" will be  a custom schedule."];
                                   }
                                   dayLabel.textColor = [UIColor redColor];
                                   [dayLabel setFont:[UIFont systemFontOfSize:22]];
                                   dayLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                   dayLabel.numberOfLines = 0;
                                   [dayLabel sizeToFit];
                                   [dayLabel setTextAlignment:UITextAlignmentCenter];
                                   dayLabel.frame = CGRectMake(self.view.frame.size.width / 2 - dayLabel.frame.size.width / 2, dayLabel.frame.origin.y, dayLabel.frame.size.width, dayLabel.frame.size.height);
                                   [scrollView addSubview:dayLabel];
                                   
                                   scheduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, dayLabel.frame.origin.y + dayLabel.frame.size.height + 10, self.view.frame.size.width - 20, 120)];
                                   scheduleLabel.text = schoolDay.customSchedule;
                                   [scheduleLabel setFont:[UIFont systemFontOfSize:14]];
                                   scheduleLabel.numberOfLines = 0;
                                   [scheduleLabel sizeToFit];
                                   [scheduleLabel setTextAlignment:UITextAlignmentCenter];
                                   scheduleLabel.frame = CGRectMake(self.view.frame.size.width / 2 - scheduleLabel.frame.size.width / 2, scheduleLabel.frame.origin.y, scheduleLabel.frame.size.width, scheduleLabel.frame.size.height);
                                   [scrollView addSubview:scheduleLabel];
                                   
                                   separator = [[UIView alloc] initWithFrame:CGRectMake(10, scheduleLabel.frame.origin.y + scheduleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                   separator.backgroundColor = [UIColor blackColor];
                                   [scrollView addSubview:separator];
                                   
                                   messageLabelA = [[UILabel alloc] initWithFrame:CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                   UIFont *font = [UIFont systemFontOfSize:14];
                                   [messageLabelA setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                                   messageLabelA.text = @"Today's Alerts";
                                   messageLabelA.lineBreakMode = NSLineBreakByWordWrapping;
                                   messageLabelA.numberOfLines = 0;
                                   [messageLabelA sizeToFit];
                                   messageLabelA.frame = CGRectMake(self.view.frame.size.width / 2 - messageLabelA.frame.size.width / 2, messageLabelA.frame.origin.y, messageLabelA.frame.size.width, messageLabelA.frame.size.height);
                                   [scrollView addSubview:messageLabelA];
                                   
                                   messageLabelB = [[UITextView alloc] initWithFrame:CGRectMake(10, messageLabelA.frame.origin.y + messageLabelA.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                   messageLabelB.text = schoolDay.messageString;
                                   messageLabelB.dataDetectorTypes = UIDataDetectorTypeLink;
                                   messageLabelB.editable = false;
                                   messageLabelB.scrollEnabled = false;
                                   [messageLabelB setFont:[UIFont systemFontOfSize:16]];
                                   [messageLabelB sizeToFit];
                                   [scrollView addSubview:messageLabelB];
                                   
                                   UIView *separatorX = [[UIView alloc] initWithFrame:CGRectMake(10, messageLabelB.frame.origin.y + messageLabelB.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                   separatorX.backgroundColor = [UIColor blackColor];
                                   [scrollView addSubview:separatorX];
                                   
                                   lunchLabelA = [[UILabel alloc] initWithFrame:CGRectMake(10, separatorX.frame.origin.y + separatorX.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                   [lunchLabelA setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                                   lunchLabelA.text = @"Today's Food";
                                   lunchLabelA.lineBreakMode = NSLineBreakByWordWrapping;
                                   lunchLabelA.numberOfLines = 0;
                                   [lunchLabelA sizeToFit];
                                   lunchLabelA.frame = CGRectMake(self.view.frame.size.width / 2 - lunchLabelA.frame.size.width / 2, lunchLabelA.frame.origin.y, lunchLabelA.frame.size.width, lunchLabelA.frame.size.height);
                                   [scrollView addSubview:lunchLabelA];
                                   
                                   lunchLabelB = [[UITextView alloc] initWithFrame:CGRectMake(10, lunchLabelA.frame.origin.y + lunchLabelA.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                   NSString *lunch = @"Lunch: ";
                                   lunchLabelB.text = [@"Breakfast: " stringByAppendingString:[[[bString stringByAppendingString:@"\n\n"] stringByAppendingString:lunch] stringByAppendingString:lString]];
                                   lunchLabelB.dataDetectorTypes = UIDataDetectorTypeLink;
                                   lunchLabelB.editable = false;
                                   lunchLabelB.scrollEnabled = false;
                                   [lunchLabelB setFont:[UIFont systemFontOfSize:16]];
                                   [lunchLabelB sizeToFit];
                                   [scrollView addSubview:lunchLabelB];
                                   
                                   if ([hasImage integerValue] == 1) {
                                             //ADD IMAGE!!!
                                        [self getImageDataMethodWithCompletion:^(NSError *error, NSMutableArray *returnData) {
                                             
                                             imageData = [returnData objectAtIndex:0];
                                             UIImage *image = [[UIImage alloc] init];
                                             
                                             image = [UIImage imageWithData:imageData];
                                             
                                             UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, lunchLabelB.frame.origin.y + lunchLabelB.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                             separator.backgroundColor = [UIColor blackColor];
                                             [scrollView addSubview:separator];
                                             
                                             imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             UIFont *font = [UIFont systemFontOfSize:14];
                                             [imageLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                                             imageLabel.text = @"Picture of the Day";
                                             imageLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                             imageLabel.numberOfLines = 0;
                                             [imageLabel sizeToFit];
                                             imageLabel.frame = CGRectMake(self.view.frame.size.width / 2 - imageLabel.frame.size.width / 2, imageLabel.frame.origin.y, imageLabel.frame.size.width, imageLabel.frame.size.height);
                                             [scrollView addSubview:imageLabel];
                                             
                                             UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 300)];
                                             
                                             if (image.size.width > self.view.frame.size.width - 20) {
                                                  image = [[AppManager getInstance] imageFromImage:image scaledToWidth:self.view.frame.size.width - 20];
                                             }
                                             imageView.image = image;
                                             [imageView sizeToFit];
                                             imageView.frame = CGRectMake(self.view.frame.size.width / 2 - imageView.frame.size.width / 2, imageLabel.frame.origin.y + imageLabel.frame.size.height + 10, imageView.frame.size.width, imageView.frame.size.height);
                                             [scrollView addSubview:imageView];
                                             
                                             imageLabelB = [[UITextView alloc] initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             [imageLabelB setFont:[UIFont systemFontOfSize:16]];
                                             imageLabelB.text = schoolDay.imageString;
                                             imageLabelB.editable = false;
                                             imageLabelB.scrollEnabled = false;
                                             imageLabelB.dataDetectorTypes = UIDataDetectorTypeLink;
                                             [imageLabelB sizeToFit];
                                             [scrollView addSubview:imageLabelB];
                                             
                                             self.automaticallyAdjustsScrollViewInsets = YES;
                                             UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 120, 0);
                                             scrollView.contentInset = adjustForTabbarInsets;
                                             scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
                                             CGRect contentRect = CGRectZero;
                                             for (UIView *view in scrollView.subviews) {
                                                  contentRect = CGRectUnion(contentRect, view.frame);
                                             }
                                             scrollView.contentSize = contentRect.size;
                                             
                                             [self.view addSubview:scrollView];
                                             
                                             [activity stopAnimating];
                                        }];
                                   }
                                   else {
                                        self.automaticallyAdjustsScrollViewInsets = YES;
                                        UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 120, 0);
                                        scrollView.contentInset = adjustForTabbarInsets;
                                        scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
                                        CGRect contentRect = CGRectZero;
                                        for (UIView *view in scrollView.subviews) {
                                             contentRect = CGRectUnion(contentRect, view.frame);
                                        }
                                        scrollView.contentSize = contentRect.size;
                                        
                                        [self.view addSubview:scrollView];
                                        
                                        [activity stopAnimating];
                                   }
                              } else {
                                   [self getScheduleStringMethodWithCompletion:^(NSError *error, NSMutableArray *returnSchedule, NSString *theBreakfastString, NSString *theLunchString) {
                                             //
                                        if (error != nil) {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Error fetching data from server. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                             [alertView show];
                                             dispatch_async(dispatch_get_main_queue(), ^ {
                                                  [activity stopAnimating];
                                                  UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewWillAppear:)];
                                                  self.navigationItem.rightBarButtonItem = barButtonItem;
                                                  [activity startAnimating];
                                                  [barButtonItem release];
                                             });
                                        } else {
                                             scheduleType = [returnSchedule objectAtIndex:0];
                                             scheduleType.scheduleString = [[returnSchedule objectAtIndex:0] objectForKey:@"scheduleString"];
                                             scheduleType.fullScheduleString = [[returnSchedule objectAtIndex:0] objectForKey:@"fullScheduleString"];
                                             
                                             titleLabelB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
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
                                             
                                             UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabelC.frame.origin.y + titleLabelC.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                             separator.backgroundColor = [UIColor blackColor];
                                             [scrollView addSubview:separator];
                                             
                                             dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             NSDateFormatter* day = [[NSDateFormatter alloc] init];
                                             [day setDateFormat: @"EEEE"];
                                             NSString *today = [day stringFromDate:[NSDate date]];
                                             dateFormatter = [[NSDateFormatter alloc] init];
                                                  // this is imporant - we set our input date format to match our input string
                                                  // if format doesn't match you'll get nil from your string, so be careful
                                             [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                                             NSDate *dateFromString = [[NSDate alloc] init];
                                                  // voila!
                                             dateFromString = [dateFormatter dateFromString:schoolDay.schoolDate];
                                             NSString *actual = [day stringFromDate:dateFromString];
                                             if ([today isEqualToString:actual]) {
                                                  dayLabel.text = [@"Today is " stringByAppendingString:scheduleType.fullScheduleString];
                                             } else {
                                                  dayLabel.text = [[actual stringByAppendingString:@" will be "] stringByAppendingString:scheduleType.fullScheduleString];
                                             }
                                             if (scheduleType.alertNeeded == YES) {
                                                  dayLabel.textColor = [UIColor redColor];
                                             }
                                             [dayLabel setFont:[UIFont systemFontOfSize:22]];
                                             dayLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                             dayLabel.numberOfLines = 0;
                                             [dayLabel sizeToFit];
                                             [dayLabel setTextAlignment:UITextAlignmentCenter];
                                             dayLabel.frame = CGRectMake(self.view.frame.size.width / 2 - dayLabel.frame.size.width / 2, dayLabel.frame.origin.y, dayLabel.frame.size.width, dayLabel.frame.size.height);
                                             [scrollView addSubview:dayLabel];
                                             
                                             scheduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, dayLabel.frame.origin.y + dayLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
                                             scheduleLabel.text = scheduleType.scheduleString;
                                             [scheduleLabel setFont:[UIFont systemFontOfSize:14]];
                                             scheduleLabel.numberOfLines = 0;
                                             [scheduleLabel sizeToFit];
                                             [scheduleLabel setTextAlignment:UITextAlignmentCenter];
                                             scheduleLabel.frame = CGRectMake(self.view.frame.size.width / 2 - scheduleLabel.frame.size.width / 2, scheduleLabel.frame.origin.y, scheduleLabel.frame.size.width, scheduleLabel.frame.size.height);
                                             [scrollView addSubview:scheduleLabel];
                                             
                                             separator = [[UIView alloc] initWithFrame:CGRectMake(10, scheduleLabel.frame.origin.y + scheduleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                             separator.backgroundColor = [UIColor blackColor];
                                             [scrollView addSubview:separator];
                                             
                                             messageLabelA = [[UILabel alloc] initWithFrame:CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             UIFont *font = [UIFont systemFontOfSize:14];
                                             [messageLabelA setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                                             messageLabelA.text = @"Today's Alerts";
                                             messageLabelA.lineBreakMode = NSLineBreakByWordWrapping;
                                             messageLabelA.numberOfLines = 0;
                                             [messageLabelA sizeToFit];
                                             messageLabelA.frame = CGRectMake(self.view.frame.size.width / 2 - messageLabelA.frame.size.width / 2, messageLabelA.frame.origin.y, messageLabelA.frame.size.width, messageLabelA.frame.size.height);
                                             [scrollView addSubview:messageLabelA];
                                             
                                             messageLabelB = [[UITextView alloc] initWithFrame:CGRectMake(10, messageLabelA.frame.origin.y + messageLabelA.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             messageLabelB.text = schoolDay.messageString;
                                             messageLabelB.dataDetectorTypes = UIDataDetectorTypeLink;
                                             messageLabelB.editable = false;
                                             messageLabelB.scrollEnabled = false;
                                             [messageLabelB setFont:[UIFont systemFontOfSize:16]];
                                             [messageLabelB sizeToFit];
                                             [scrollView addSubview:messageLabelB];
                                             
                                             UIView *separatorX = [[UIView alloc] initWithFrame:CGRectMake(10, messageLabelB.frame.origin.y + messageLabelB.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                             separatorX.backgroundColor = [UIColor blackColor];
                                             [scrollView addSubview:separatorX];
                                             
                                             lunchLabelA = [[UILabel alloc] initWithFrame:CGRectMake(10, separatorX.frame.origin.y + separatorX.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             [lunchLabelA setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                                             lunchLabelA.text = @"Today's Food";
                                             lunchLabelA.lineBreakMode = NSLineBreakByWordWrapping;
                                             lunchLabelA.numberOfLines = 0;
                                             [lunchLabelA sizeToFit];
                                             lunchLabelA.frame = CGRectMake(self.view.frame.size.width / 2 - lunchLabelA.frame.size.width / 2, lunchLabelA.frame.origin.y, lunchLabelA.frame.size.width, lunchLabelA.frame.size.height);
                                             [scrollView addSubview:lunchLabelA];
                                             
                                             lunchLabelB = [[UITextView alloc] initWithFrame:CGRectMake(10, lunchLabelA.frame.origin.y + lunchLabelA.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                             NSString *lunch = @"Lunch: ";
                                             lunchLabelB.text = [@"Breakfast: " stringByAppendingString:[[[theBreakfastString stringByAppendingString:@"\n\n"] stringByAppendingString:lunch] stringByAppendingString:theLunchString]];
                                             lunchLabelB.dataDetectorTypes = UIDataDetectorTypeLink;
                                             lunchLabelB.editable = false;
                                             lunchLabelB.scrollEnabled = false;
                                             [lunchLabelB setFont:[UIFont systemFontOfSize:16]];
                                             [lunchLabelB sizeToFit];
                                             [scrollView addSubview:lunchLabelB];
                                             
                                             if ([hasImage integerValue] == 1) {
                                                       //ADD IMAGE!!!
                                                  [self getImageDataMethodWithCompletion:^(NSError *error, NSMutableArray *returnData) {
                                                       
                                                       imageData = [returnData objectAtIndex:0];
                                                       UIImage *image = [[UIImage alloc] init];
                                                       
                                                       image = [UIImage imageWithData:imageData];
                                                       
                                                       UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, lunchLabelB.frame.origin.y + lunchLabelB.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                                                       separator.backgroundColor = [UIColor blackColor];
                                                       [scrollView addSubview:separator];
                                                       
                                                       imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                                       UIFont *font = [UIFont systemFontOfSize:14];
                                                       [imageLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                                                       imageLabel.text = @"Picture of the Day";
                                                       imageLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                                       imageLabel.numberOfLines = 0;
                                                       [imageLabel sizeToFit];
                                                       imageLabel.frame = CGRectMake(self.view.frame.size.width / 2 - imageLabel.frame.size.width / 2, imageLabel.frame.origin.y, imageLabel.frame.size.width, imageLabel.frame.size.height);
                                                       [scrollView addSubview:imageLabel];
                                                       
                                                       UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 300)];
                                                       
                                                       if (image.size.width > self.view.frame.size.width - 20) {
                                                            image = [[AppManager getInstance] imageFromImage:image scaledToWidth:self.view.frame.size.width - 20];
                                                       }
                                                       imageView.image = image;
                                                       [imageView sizeToFit];
                                                       imageView.frame = CGRectMake(self.view.frame.size.width / 2 - imageView.frame.size.width / 2, imageLabel.frame.origin.y + imageLabel.frame.size.height + 10, imageView.frame.size.width, imageView.frame.size.height);
                                                       [scrollView addSubview:imageView];
                                                       
                                                       imageLabelB = [[UITextView alloc] initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, self.view.frame.size.width - 20, 20)];
                                                       [imageLabelB setFont:[UIFont systemFontOfSize:16]];
                                                       imageLabelB.text = schoolDay.imageString;
                                                       imageLabelB.editable = false;
                                                       imageLabelB.scrollEnabled = false;
                                                       imageLabelB.dataDetectorTypes = UIDataDetectorTypeLink;
                                                       [imageLabelB sizeToFit];
                                                       [scrollView addSubview:imageLabelB];
                                                       
                                                       self.automaticallyAdjustsScrollViewInsets = YES;
                                                       UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 120, 0);
                                                       scrollView.contentInset = adjustForTabbarInsets;
                                                       scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
                                                       CGRect contentRect = CGRectZero;
                                                       for (UIView *view in scrollView.subviews) {
                                                            contentRect = CGRectUnion(contentRect, view.frame);
                                                       }
                                                       scrollView.contentSize = contentRect.size;
                                                       
                                                       [self.view addSubview:scrollView];
                                                       
                                                       [activity stopAnimating];
                                                  }];
                                             }
                                             else {
                                                  self.automaticallyAdjustsScrollViewInsets = YES;
                                                  UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 120, 0);
                                                  scrollView.contentInset = adjustForTabbarInsets;
                                                  scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
                                                  CGRect contentRect = CGRectZero;
                                                  for (UIView *view in scrollView.subviews) {
                                                       contentRect = CGRectUnion(contentRect, view.frame);
                                                  }
                                                  scrollView.contentSize = contentRect.size;
                                                  
                                                  [self.view addSubview:scrollView];
                                                  
                                                  [activity stopAnimating];
                                             }
                                        }
                                   } forType:schoolDay.scheduleType forBreakfast:breakfastString forLunch:lunchString];
                              }
                         }
                    } forB:breakfastString forL:lunchString];
               }
          }];
     }
}

- (void)getImageDataMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnData))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *array = [NSMutableArray array];
     PFQuery *query = [SchoolDayStructure query];
     [query whereKey:@"schoolDayID" equalTo:schoolDay.schoolDayID];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
          SchoolDayStructure *structure = (SchoolDayStructure *)object;
          PFFile *imageFile = structure.imageFile;
          [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
               theError = error;
               [array addObject:data];
               dispatch_group_leave(serviceGroup);
          }];
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError) {
               overallError = theError;
          }
          completion(overallError, array);
     });
}

- (void)viewDidLoad {
	[super viewDidLoad];
     
     NSString *loadString = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloadHomePage"];
     if ([loadString isEqual:@"0"]) {
          [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reloadHomePage"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewWillAppear:)];
          self.navigationItem.rightBarButtonItem = barButtonItem;
     }
     
     [self getCountMethodWithCompletion:^(NSInteger count) {
          NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNewsArticles"];
          NSInteger read = array.count;
          NSNumber *number = [NSNumber numberWithInt:(count - read)];
          [self getCountTwoMethodWithCompletion:^(NSInteger count2) {
               NSNumber *updates = [NSNumber numberWithInt:count2];
               NSNumber *updatesSeen = [[NSUserDefaults standardUserDefaults] objectForKey:@"ECviewed"];
               if (updatesSeen) {
                    if ([updatesSeen integerValue] >= [updates integerValue]) {
                         updates = [NSNumber numberWithInt:0];
                    } else {
                         updates = [NSNumber numberWithInt:[updates integerValue] - [updatesSeen integerValue]];
                    }
               } else {
                    updates = [NSNumber numberWithInt:[updates integerValue] - [updatesSeen integerValue]];
               }
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
                    [self getCountFourMethodWithCompletion:^(NSInteger count4) {
                         NSMutableArray *alertsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readAlerts"];
                         NSInteger read = alertsArray.count;
                         NSNumber *readNumber = [NSNumber numberWithInt:(count4 - read)];
                         if ([readNumber integerValue] > 0) {
                              [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [readNumber stringValue];
                         }
                         else
                              [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                    }];
               }];
          }];
          
     }];
}

- (void)postPicture {
     
}

- (NSString *)getDayFromInteger:(int)day {
     switch (day) {
          case 1:
               return @"Monday";
               break;
          
          case 2:
               return @"Tuesday";
               break;
          
          case 3:
               return @"Wednesday";
               break;
          
          case 4:
               return @"Thursday";
               break;
               
          case 5:
               return @"Friday";
               break;
          
          default:
               return nil;
               break;
     }
}

- (void)getScheduleStringMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *schedule, NSString *breakfast, NSString *lunch))completion forType:(NSString *)string forBreakfast:(NSString *)breakfast forLunch:(NSString *)lunch {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *schedule = [NSMutableArray array];
     PFQuery *query = [ScheduleType query];
     [query whereKey:@"typeID" equalTo:string];
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          [schedule addObjectsFromArray:objects];
          theError = error;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError) {
               overallError = theError;
          }
          completion(overallError, schedule, breakfast, lunch);
     });
}

- (void)getCurrentSchoolDayMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *schoolDay, NSString *bString, NSString *lString))completion forB:(NSString *)breakfastTwo forL:(NSString *)lunchTwo {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     __block SchoolDayStructure *theDay;
     NSMutableArray *array = [NSMutableArray array];
     PFQuery *query = [SchoolDayStructure query];
     [query orderByAscending:@"schoolDayID"];
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          theError = error;
          [array addObjectsFromArray:objects];
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError) {
               overallError = theError;
          }
          completion(overallError, array, breakfastTwo, lunchTwo);
     });
}

- (void)getCurrentLunchMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *schoolDay))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *array = [NSMutableArray array];
     PFQuery *query = [LunchMenusStructure query];
     [query orderByAscending:@"lunchStructureID"];
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          theError = error;
          [array addObjectsFromArray:objects];
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          NSError *overallError = nil;
          if (theError) {
               overallError = theError;
          }
          completion(overallError, array);
     });
}

- (void)getCountFourMethodWithCompletion:(void (^)(NSInteger count))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFQuery *query = [AlertStructure query];
     __block int count;
     [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
          count = number;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(count);
     });
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
