//
//  FirstViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [scrollerhome setScrollEnabled:YES];
    [scrollerhome setContentSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width, 1000)];
    CGSize ScreenSize = [[UIScreen mainScreen] bounds].size;
    self.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
