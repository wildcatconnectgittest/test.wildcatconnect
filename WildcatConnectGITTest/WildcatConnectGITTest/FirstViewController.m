//
//  FirstViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>
#import "TestStructure.h"

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
     PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
     testObject[@"foo"] = @"bar";
     [testObject saveInBackground];
     TestStructure *testStructure = [[TestStructure alloc] init];
     testStructure.isSelected = true;
     testStructure.testStructureIndex = 5;
     testStructure.testStructureName = @"Testing...";
     [testStructure saveInBackground];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
